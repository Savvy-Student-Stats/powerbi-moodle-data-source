// AskMoodleForTable (function)
// Make a request to the Moodle Webservice
//
// @param wsfunction {text}
// @param extraUrlParams {text}
// @return {table}
//
// @since 2021-02-10
// @author code@sqrl.c
//

// https://exceloffthegrid.com/power-query-custom-functions/

// START CONFIG (MOVED TO POWER BI PARAMS)
//              (left here for future debugging)
//
// MOODLE_BASE_URL = "https://thehub.fsd38.ab.ca/",
// MOODLE_KEY = "f5c207c1b39335b60b50b69c169bdc0c",
// MOODLE_USER_ID = "10335",
//
// END

// Source = Json.Document(File.Contents(CONF_MOODLE_DIR & "01-courses-core_enrol_get_users_courses.json")),
(wsfunction as text, optional extraParams as text) =>
    let

        fullServiceUrlBase =
                            MOODLE_SVC_URL
                            & "&wsfunction=" & wsfunction
                            & "&wstoken=" & MOODLE_KEY,

        fullServiceUrl =
            if (extraParams <> null) then
                fullServiceUrlBase & "&" & extraParams
            else
                fullServiceUrlBase
        ,

        // Make Request to Moodle Web Service
        WebsvcResponse = Web.Contents(fullServiceUrl),

        // Convert Moodle's JSON Response
        // https://docs.microsoft.com/en-us/powerquery-m/json-document
        Source = Json.Document(WebsvcResponse)


        // ,

        // // Convert List to Table by applying the optional
        // // splitting function, splitter, to each item in the list.
        // // https://docs.microsoft.com/en-us/powerquery-m/table-fromlist
        // finalTable = Table.FromList(
        //     Source,
        //     Splitter.SplitByNothing(),
        //     null,
        //     null,
        //     ExtraValues.Error
        // )
in
    Source

// ///~///~///
// # Note
// 2021-02-10: Could not get WS working with posting form dataq.
// After playing with postman, and reading https://moodle.org/plugins/webservice_restjson
// I discovered any param can be sent through the URL params.
// Kind of gross passing in an API key in a loggable way, but oh well.
//
// body = Json.Document("{
//    ""wsfunction"": ""core_enrol_get_users_course"",
//    ""wstoken"": """ & MOODLE_KEY & """,
//    ""userid"": """ & MOODLE_USER_ID & """"
// & "}"),
//
// bodyQueryString = Uri.BuildQueryString(body),
// body =
//     "wsfunction=core_enrol_get_users_course"
//     & "&wstoken=" & MOODLE_KEY
//     & "&userid=" & MOODLE_USER_ID
// ,
//
// ///~///~///
