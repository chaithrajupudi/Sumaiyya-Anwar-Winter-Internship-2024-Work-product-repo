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


function initializeAIGenie() {
    _axiosAgent = new Https.Agent
        ({
            rejectUnauthorized: false
        });

    prepareAllUrls();
}


function processTranslationResponse(response) {
    const translateResponseList = response.data.results;
    return translateResponseList;
}


function prepareProductInfo(request, type) {
    const productInfo = {};
    productInfo.text = request.body.text;
    productInfo.language = request.body.language;
    productInfo.desc = request.body.desc;
    productInfo.prompt = request.body.prompt;
    productInfo.type = type;
    productInfo.modelId = request.headers.modelid;
    return productInfo;
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


async function getProductDetails(productInfo, textInfo) {
    const requestOptions = {};
    requestOptions.httpsAgent = _axiosAgent;

    const requestBody = {};
    requestBody.instances = [];

    const genAIHeaders = (productInfo.type === "short") ? prepareShortHeaders(productInfo.modelId,
        productInfo.endpointId)
        : prepareLongHeaders(productInfo.modelId,
            productInfo.endpointId);
    requestOptions.headers = genAIHeaders;

    try {
        if (textInfo != null) {
            if (textInfo.sourceLanguage == "en-US") {
                productInfo.desc = `${textInfo.text}\n\n${productInfo.desc}`;
            }
            else {
                const translatedResponse = await translateText(textInfo);
                productInfo.desc = `${translatedResponse.target}\n\n${productInfo.desc}`;
            }
        }

        const promptInfo = {};
        promptInfo.prompt = `${productInfo.prompt}\n${productInfo.desc}`;
        requestBody.instances.push(promptInfo);
        const response = await Axios.post(`${_allUrls[KGenAITextlib]}/genai/text`,
            requestBody, requestOptions);
        let genAIResponse = processGenericResponse(response);
        if ((textInfo != null) && (textInfo.sourceLanguage != "en-US")) {
            const translatedContent = await translateAIResponse(genAIResponse.content,
                textInfo.sourceLanguage);
            genAIResponse.translatedContent = translatedContent;
        }
        return genAIResponse;
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
 * @fires /product/title
 * @method POST
 * @description Get curated Title for a Product from Product briefings
 */
_express.post("/product/title", async (request, response) => {
    const productInfo = prepareProductInfo(request, "short");
    const results = {};

    try {
        const responseList = await getProductDetails(productInfo, null);
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