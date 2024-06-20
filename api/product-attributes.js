const Http = require("http");
const Https = require("https");
const DotEnv = require("dotenv");
const Express = require("express");
const Cors = require("cors");
const Axios = require('axios');

let _express = Express();
let _server = Http.createServer(_express);
let _axiosAgent = null;
let _allUrls = {};

const KStorageLib = "storagelib";
const KVisionLib = "visionlib";
const KSpeechib = "speechlib";
const KSTranslateLib = "translatelib";
const KGenAITextlib = "genai-textlib";
const KGenAIImagelib = "genai-imagelib";
const KVectorSearchlib = "vector-searchlib";
const KGenAITextV2lib = "genai-textlib-v2";
const KGenAIMultimodalV2lib = "genai-multimodallib-v2";

DotEnv.config();

_express.use(Express.json
    ({
        extended: true,
        limit: '10mb'
    }));


_express.use(Express.urlencoded
    ({
        extended: true
    }));


_express.use(Cors
    ({
        origin: "*"
    }));



function processGenericResponse(response) {
    const genaiResponse = response.data.results;
    return genaiResponse;
}

function prepareErrorMessage(exception) {
    const code = exception.response.status;
    const message = exception.response.data.results;

    const errorInfo = {};
    errorInfo.message = message;
    errorInfo.code = ((code == undefined) || (code < 400)) ? 500 : code;;
    return errorInfo;
}


function initializeAIGenie() {
    _axiosAgent = new Https.Agent
        ({
            rejectUnauthorized: false
        });

    prepareAllUrls();
}


function prepareAllUrls() {
    _allUrls[KStorageLib] = `${process.env.STORAGELIB_HOST}`;
    _allUrls[KVisionLib] = `${process.env.VISIONLIB_HOST}`;
    _allUrls[KSpeechib] = `${process.env.SPEECHLIB_HOST}`;
    _allUrls[KSTranslateLib] = `${process.env.TRANSLATELIB_HOST}`;
    _allUrls[KGenAITextlib] = `${process.env.GENAI_TEXTLIB_HOST}`;
    _allUrls[KGenAIImagelib] = `${process.env.GENAI_IMAGELIB_HOST}`;
    _allUrls[KVectorSearchlib] = `${process.env.GENAI_VECTORSEARCHLIB_HOST}`;
    _allUrls[KGenAITextV2lib] = `${process.env.GENAI_TEXTLIB_V2_HOST}`;
    _allUrls[KGenAIMultimodalV2lib] = `${process.env.GENAI_MULTILIB_V2_HOST}`;
}


function prepareShortHeaders(endpointId) {
    const genAIHeaders = {};
    genAIHeaders.temperature = 0.4;
    genAIHeaders.maxtokens = 1024;
    genAIHeaders.topk = 40;
    genAIHeaders.topp = 0.8;
    genAIHeaders.endpointid = endpointId;
    return genAIHeaders;
}


function processTranslationResponse(response) {
    const translateResponseList = response.data.results;
    return translateResponseList;
}


function prepareImageAttributesInfo(request) {
    const imageAttributesInfo = {};
    imageAttributesInfo.attributes = request.body.attributes;
    imageAttributesInfo.prompt = request.body.prompt;
    imageAttributesInfo.desc = request.body.desc;
    imageAttributesInfo.modelId = request.headers.modelid;
    imageAttributesInfo.endpointId = request.headers.endpointid;
    return imageAttributesInfo;
}


async function translateAIResponse(originalContent, targetLanguage) {
    const textInfo = {};
    textInfo.text = originalContent;
    textInfo.sourceLanguage = "en-US";
    textInfo.targetLanguage = targetLanguage;

    const translatedResponse = await translateText(textInfo);
    translatedContent = translatedResponse.target;
    return translatedContent;
}


async function refineAttributes(imageAttributesInfo) {
    const requestOptions = {};
    requestOptions.httpsAgent = _axiosAgent;

    const requestBody = {};
    requestBody.instances = [];

    const genAIHeaders = prepareShortHeaders(imageAttributesInfo.modelId,
        imageAttributesInfo.endpointId);
    requestOptions.headers = genAIHeaders;

    try {
        const promptInfo = {};
        promptInfo.prompt = `${imageAttributesInfo.prompt}\n${imageAttributesInfo.attributes}\n\n${imageAttributesInfo.desc}`;
        requestBody.instances.push(promptInfo);
        const response = await Axios.post(`${_allUrls[KGenAITextlib]}/genai/text`,
            requestBody, requestOptions);
        let genaiResponse = processGenericResponse(response);
        return genaiResponse;
    }
    catch (exception) {
        throw exception;
    }
}


async function translateText(textInfo) {
    const requestOptions = {};
    requestOptions.httpsAgent = _axiosAgent;

    requestOptions.headers = {};
    requestOptions.headers =
    {
        "content-type": "application/json",
        "mime-type": "text/plain"
    }

    const requestBody = [];
    requestBody.push(textInfo.text);

    try {
        const response = await Axios.post(`${_allUrls[KSTranslateLib]}/translate/text?src=${textInfo.sourceLanguage}&trg=${textInfo.targetLanguage}`,
            requestBody, requestOptions);
        const translateResponseList = processTranslationResponse(response);
        return translateResponseList[0];
    }
    catch (exception) {
        throw exception;
    }
}


/**
 * @fires /product/attribs
 * @method POST
 * @description Get a curated set of attributes from 
 * a given set of attributes
 */
_express.post("/product/attribs", async (request, response) => {
    const imageAttributesInfo = prepareImageAttributesInfo(request);
    const results = {};

    try {
        const responseList = await refineAttributes(imageAttributesInfo);
        results.results = responseList;
        response.send(results);
    }
    catch (exception) {
        let errorInfo = prepareErrorMessage(exception);
        results.results = errorInfo.message;
        response.status(errorInfo.code).send(results);
    }
});


/* API DEFINITIONS - END */

var port = process.env.port || process.env.PORT || 6067;
_server.listen(port);

initializeAIGenie();

console.log("Server running at http://localhost:%d", port);