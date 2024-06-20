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


function prepareMatchingInfo(request) {
    const matchingInfo = {};
    matchingInfo.text = request.body.text;
    matchingInfo.language = request.body.language;
    matchingInfo.bucket = request.body.gcsbucket;
    matchingInfo.fileName = request.body.filename;
    matchingInfo.indexId = request.body.index;
    matchingInfo.endpointId = request.body.endpoint;
    matchingInfo.matchCount = request.headers.matchcount;

    matchingInfo.headers = {};
    matchingInfo.headers.modelid = request.headers.modelid;
    return matchingInfo;
}


async function getTextEmbeddings(embeddingInfo) {
    const requestOptions = {};
    requestOptions.httpsAgent = _axiosAgent;
    requestOptions.headers = embeddingInfo.headers;

    const requestBody = {};
    requestBody.instances = [];
    requestBody.instances.push(embeddingInfo);

    try {
        const response = await Axios.post(`${_allUrls[KGenAITextlib]}/genai/text/embeddings`,
            requestBody, requestOptions);
        const genaiResponse = processGenericResponse(response);
        return genaiResponse;
    }
    catch (exception) {
        throw exception;
    }
}


async function performTextMatch(matchingInfo, textInfo) {

    try {
        if (textInfo != null) {
            if (textInfo.sourceLanguage == "en-US") {
                matchingInfo.text = `${textInfo.text}`;
            }
            else {
                const translatedResponse = await translateText(textInfo);
                matchingInfo.text = `${translatedResponse.target}`;
            }
        }

        const embeddingInfo = {};
        embeddingInfo.content = matchingInfo.text;
        embeddingInfo.headers = matchingInfo.headers;

        const embeddingsResponse = await getTextEmbeddings(embeddingInfo);
        const embeddingValues = embeddingsResponse.embeddings.values;

        const requestOptions = {};
        requestOptions.httpsAgent = _axiosAgent;

        const findInfo = {};
        findInfo.deployedIndexId = matchingInfo.indexId;
        findInfo.indexEndpointId = matchingInfo.endpointId;

        const queryInfo = {};
        queryInfo.neighborCount = matchingInfo.matchCount;

        const datapoint = {};
        datapoint.datapoint_id = "0";

        const featureVector = [];
        featureVector.push(embeddingValues);
        datapoint.feature_vector = featureVector;
        queryInfo.datapoint = datapoint;
        findInfo.queries = [queryInfo];

        const requestBody = findInfo;
        const response = await Axios.post(`${_allUrls[KVectorSearchlib]}/vector/search/neighbour`,
            requestBody, requestOptions);
        const genaiResponse = processGenericResponse(response);
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
 * @fires /text/match
 * @method POST
 * @description Get curated Description for a Product from Product briefings
 */
_express.post("/text/match", async (request, response) => {
    const matchingInfo = prepareMatchingInfo(request);
    const results = {};

    try {
        const responseList = await performTextMatch(matchingInfo, null);
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