// MOODLE_BASE_URL
// "https://www.example.com/" meta [IsParameterQuery=true, List={"https://www.example.com/"}, DefaultValue="https://www.example.com/", Type="Text", IsParameterQueryRequired=true]
"https://www.example.com/" meta [IsParameterQuery=true, Type="Text",  IsParameterQueryRequired=true]

// MOODLE_KEY
"YOUR_KEY_HERE_EXAMPLE_00a9cf9ca128e95c417a1858bdd9d41e" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]

// MOODLE_SVC_URL
let
    Source = MOODLE_BASE_URL & "/webservice/rest/server.php?moodlewsrestformat=json&wstoken=" & MOODLE_KEY
in
    Source

// AskMoodleFor
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
// MOODLE_BASE_URL = "https://www.example.com/",
// MOODLE_KEY = "YOUR_KEY_HERE_EXAMPLE_00a9cf9ca128e95c417a1858bdd9d41e",
// MOODLE_USER_ID = "12345",
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

// MOODLE_USER_ID
"12345" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]

// zzz-source-Courses
// source_get_users_courses
// load response from web service.
// The `Assignment` table then references this and expands as needed.
let
    //&wsfunction=core_enrol_get_users_courses

    RemoteData = AskMoodleFor("core_enrol_get_users_courses", "userid=" & MOODLE_USER_ID),

    RemoteDataTable = Table.FromList(RemoteData, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    #"Renamed Columns" = Table.RenameColumns(RemoteDataTable,{{"Column1", "C"}}),
    #"Expanded C" = Table.ExpandRecordColumn(#"Renamed Columns", "C", {"id", "displayname", "summary", "format", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "overviewfiles"}, {"C.id", "C.displayname", "C.summary", "C.format", "C.enablecompletion", "C.completionhascriteria", "C.completionusertracked", "C.category", "C.progress", "C.completed", "C.startdate", "C.enddate", "C.marker", "C.lastaccess", "C.isfavourite", "C.overviewfiles"})
in
    #"Expanded C"


// 2021-02-10: Could not get WS working with posting form dataq.
// After playing with postman, and reading https://moodle.org/plugins/webservice_restjson
// I discovered any param can be sent through the URL params.
// Kind of gross passing in an API key in a loggable way, but oh well.

// body = Json.Document("{
    // ""wsfunction"": ""core_enrol_get_users_course"",
    // ""wstoken"": """ & MOODLE_KEY & """,
    // ""userid"": """ & MOODLE_USER_ID & """"
// & "}"),
//
// bodyQueryString = Uri.BuildQueryString(body),
// body =
//     "wsfunction=core_enrol_get_users_course"
//     & "&wstoken=" & MOODLE_KEY
//     & "&userid=" & MOODLE_USER_ID
// ,

// Courses
// Course
let
    Source = #"zzz-source-Courses",
    #"Removed Columns" = Table.RemoveColumns(Source,{"Course.idnumber"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Removed Columns",{"Course.id", "Course.shortname", "Course.displayname", "Course.summary", "Course.summaryformat", "Course.format", "Course.showgrades", "Course.enablecompletion", "Course.completionhascriteria", "Course.completionusertracked", "Course.category", "Course.progress", "Course.completed", "Course.startdate", "Course.enddate", "Course.marker", "Course.lastaccess"})
in
    #"Removed Other Columns"

// zzz-source-gradebooks-raw
// zzz-source-gradereport_user_get_grade_items
// @since 2021-02-10
let

    // thanks `#table` https://blog.crossjoin.co.uk/2016/06/03/creating-tables-in-power-bipower-query-m-code-using-table/
    // COURSE_IDS = { 780,671,673,684,702 },
    NewTable = #table(
        {"GI.courseId"},
        {
            {780},
            {671},
            {673},
            {684},
            {702}
        }
    ),

    #"Get Gradebooks from Moodle" = Table.AddColumn(
        NewTable,
        "MoodleResponse",
        each AskMoodleForGradebookByCourse([GI.courseId])
    ),


    #"Expanded AskMoodleForGradebook" = Table.ExpandRecordColumn(
        #"Get Gradebooks from Moodle",
        "MoodleResponse",
        {"usergrades"},
        {"usergrades"}
    ),
    #"Expanded usergrades" = Table.ExpandListColumn(
        #"Expanded AskMoodleForGradebook",
        "usergrades"
    ),
    #"Expanded usergrades1" = Table.ExpandRecordColumn(
        #"Expanded usergrades",
        "usergrades",
        {
            // "courseid",
            // "userid",
            // "userfullname",
            // "maxdepth",
            "gradeitems"
        },
        {
            // "usergrades.courseid",
            // "usergrades.userid",
            // "userfullname",
            // "maxdepth",
            "gradeitems"
        }
    ),

    #"Expanded gradeitems" = Table.ExpandListColumn(
        #"Expanded usergrades1",
        "gradeitems"
    ),

    #"Expanded gradeitems1" = Table.ExpandRecordColumn(
        #"Expanded gradeitems",
        "gradeitems",
        {
            "id",
            "itemname",
            "itemtype",
            "itemmodule",
            "iteminstance",
            "itemnumber",
            "categoryid",
            "outcomeid",
            "scaleid",
            "locked",
            "graderaw",
            "gradedatesubmitted",
            "gradedategraded",
            "gradehiddenbydate",
            "gradeneedsupdate",
            "gradeishidden",
            "gradeislocked",
            "gradeisoverridden",
            "gradeformatted",
            "feedback",
            "feedbackformat",
            "cmid"
        },
        {
            "GI.id",
            "GI.itemname",
            "GI.itemtype",
            "GI.itemmodule",
            "GI.iteminstance",
            "GI.itemnumber",
            "GI.categoryid",
            "GI.outcomeid",
            "GI.scaleid",
            "GI.locked",
            "GI.graderaw",
            "GI.gradedatesubmitted",
            "GI.gradedategraded",
            "GI.gradehiddenbydate",
            "GI.gradeneedsupdate",
            "GI.gradeishidden",
            "GI.gradeislocked",
            "GI.gradeisoverridden",
            "GI.gradeformatted",
            "GI.feedback",
            "GI.feedbackformat",
            "GI.cmid"
         }
    ),
    #"Removed Other Columns" = Table.SelectColumns(
        #"Expanded gradeitems1",
        {
            "GI.id",
            "GI.itemname",
            "GI.itemtype",
            "GI.itemmodule",
            "GI.iteminstance",
            "GI.itemnumber",
            "GI.categoryid",
            "GI.outcomeid",
            "GI.scaleid",
            "GI.locked",
            "GI.graderaw",
            "GI.gradedatesubmitted",
            "GI.gradedategraded",
            "GI.gradehiddenbydate",
            "GI.gradeneedsupdate",
            "GI.gradeishidden",
            "GI.gradeislocked",
            "GI.gradeisoverridden",
            "GI.gradeformatted",
            "GI.feedback",
            "GI.feedbackformat",
            "GI.cmid"
        }
    ),
    #"Sorted Rows" = Table.Sort(#"Removed Other Columns",{{"GI.id", Order.Descending}})

    // ADD DATE COLUMNS

in
    #"Sorted Rows"

// AskMoodleForGradebookByCourse
// AskMoodleForGradebook.dax
// @since 2021-02-10
(courseid as number) =>
    let
        Source = AskMoodleFor(
            "gradereport_user_get_grade_items",
             "userid=" & MOODLE_USER_ID
             & "&courseid=" & Number.ToText(courseid))
in
    Source

// Grades
let
    Source = #"zzz-source-gradebooks-raw",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"gradeitems.id", "gradeitems.itemname", "gradeitems.iteminstance", "gradeitems.categoryid", "gradeitems.outcomeid", "gradeitems.scaleid", "gradeitems.locked", "gradeitems.graderaw", "gradeitems.gradedatesubmitted", "gradeitems.gradedategraded", "gradeitems.gradehiddenbydate", "gradeitems.gradeneedsupdate", "gradeitems.gradeisoverridden", "gradeitems.gradeformatted", "gradeitems.feedback", "courseid"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Other Columns",{{"gradeitems.itemname", "GradeItem.name"}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Renamed Columns",{"GradeItem.name", "gradeitems.id", "gradeitems.iteminstance", "gradeitems.categoryid", "gradeitems.outcomeid", "gradeitems.scaleid", "gradeitems.locked", "gradeitems.graderaw", "gradeitems.gradedatesubmitted", "gradeitems.gradedategraded", "gradeitems.gradehiddenbydate", "gradeitems.gradeneedsupdate", "gradeitems.gradeisoverridden", "gradeitems.gradeformatted", "gradeitems.feedback", "courseid"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Reordered Columns",{{"gradeitems.graderaw", "Grade.raw"}, {"gradeitems.gradedatesubmitted", "Grade.dateSubmitted"}, {"gradeitems.gradedategraded", "Grade.dateGraded"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"gradeitems.gradehiddenbydate"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns",{{"gradeitems.gradeneedsupdate", "Grade.needsUpdate"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns2",{"gradeitems.gradeisoverridden"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Removed Columns1",{{"gradeitems.gradeformatted", "Grade.formattedText"}, {"gradeitems.feedback", "Grade.feedbackHtml"}, {"courseid", "Grade.courseid"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns3",{"gradeitems.locked"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Removed Columns2",{{"gradeitems.outcomeid", "Grade.outcomeid"}, {"gradeitems.scaleid", "Grade.scaleid"}, {"gradeitems.categoryid", "Grade.categoryid"}, {"gradeitems.iteminstance", "Grade.iteminstance"}, {"gradeitems.id", "Grade.id"}, {"GradeItem.name", "Grade.name"}})

    //


    // // Convert Moodle timestamps to date
    // ResultTable = AddDateColumnsFromTimestamps(
    //     #"Reordered Columns",

    //     {
    //         "gradeitems.gradedategraded",
    //         "gradeitems.gradedatesubmitted",
    //         "gradeitems.gradehiddenbydate",
    //         "gradeitems.timemodified"
    //     }
    // )
in
    // ResultTable
    #"Renamed Columns4"

// GradeItems
// GradeItems
// @since 2021-02-11

let
    Source = #"zzz-source-gradebooks-raw",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"gradeitems.id", "gradeitems.itemname", "gradeitems.iteminstance", "gradeitems.categoryid", "gradeitems.outcomeid", "gradeitems.scaleid", "gradeitems.locked", "gradeitems.graderaw", "gradeitems.gradedatesubmitted", "gradeitems.gradedategraded", "gradeitems.gradehiddenbydate", "gradeitems.gradeneedsupdate", "gradeitems.gradeisoverridden", "gradeitems.gradeformatted", "gradeitems.feedback", "courseid"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Other Columns",{{"gradeitems.itemname", "GradeItem.name"}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Renamed Columns",{"GradeItem.name", "gradeitems.id", "gradeitems.iteminstance", "gradeitems.categoryid", "gradeitems.outcomeid", "gradeitems.scaleid", "gradeitems.locked", "gradeitems.graderaw", "gradeitems.gradedatesubmitted", "gradeitems.gradedategraded", "gradeitems.gradehiddenbydate", "gradeitems.gradeneedsupdate", "gradeitems.gradeisoverridden", "gradeitems.gradeformatted", "gradeitems.feedback", "courseid"}),


    // Convert Moodle timestamps to date
    ResultTable = AddDateColumnsFromTimestamps(
        #"Reordered Columns",

        {
            "gradeitems.gradedategraded",
            "gradeitems.gradedatesubmitted",
            "gradeitems.gradehiddenbydate",
            "gradeitems.timemodified"
        }
    )
in
    ResultTable

// DEFAULT_DATE
#date(2019, 1, 1) meta [IsParameterQuery=true, List={#date(2019, 1, 1)}, DefaultValue=#date(2019, 1, 1), Type="Date", IsParameterQueryRequired=true]

// EPOCH_DATE
#date(1970, 1, 1) meta [IsParameterQuery=true, Type="Date", IsParameterQueryRequired=true]

// TimestampToDate
// TimestampToDate (function)
//
// Convert a single timestamp value (seconds since epoch),
// to a date field.
// Added column names will have `_asDate` appended to them (e.g. `myTimestamp_asDate`).
//
// @param timestamp {number} - Moodle uses seconds, NOT milliseconds, since epoch.
// @param colNames {list}
//
// @return {null} Adds `*_asDate` columns to `SourceTable`
//
// @since 2021-02-10
//
// TimestampToDate =
(timestamp as number) =>
        let
        // DEFAULT_DATE = DateTime.Date(2019, 1, 1),
        // EPOCH_DATE = #datetime(1970, 1, 1, 0, 0, 0),

        returnValue =
        if timestamp = null
        then DEFAULT_DATE
        else
            try
                DateTime.Date(
                    EPOCH_DATE + #duration(0, 0, 0, timestamp)
                )
            otherwise
                null
in
    returnValue

// AddDateColumnsFromTimestamps
// AddDateColumnsFromTimestamps (function)
//
// Convert a list of columns from timestamp (seconds since epoch),
// to a date field.
// Added column names will have `_date` appended to them (e.g. `myTimestamp_date`).
//
// @param SourceTable {table}
// @param colNames {list}
// @return {null} Adds `*_date` columns to `SourceTable`
//
// @since 2021-02-10


// ConvertTimestampColumns =
(SourceTable as table, colNames as list) =>
    let newSource = List.Accumulate(
        colNames,
        SourceTable,
        (state, colName) =>
            Table.AddColumn(
                state,
                colName & "_date",
                // "you can use the underscore „_“ to reference the current row of the table, which means the current record."
                each TimestampToDate(Record.Field(_, colName)),
                type date
            )
    )
in
    newSource

// debug_AskMoodleForCourses
let
    // passthruParams = "userid=" & MOODLE_USER_ID & "&courseid=" & Number.ToText(702),
    passthruParams = "userid=" & MOODLE_USER_ID,

    #"Get Webservice Response" =
                MOODLE_SVC_URL
                & "&wstoken=" & MOODLE_KEY
                // & "&wsfunction=" & "gradereport_user_get_grade_items"
                & "&wsfunction=" & "core_enrol_get_users_courses"
                & "&" & passthruParams,

    // Make Request to Moodle Web Service
    WebsvcResponse = Json.Document(Web.Contents(#"Get Webservice Response"))

in
    WebsvcResponse

// debug_AskMoodleForAssignments
let
    // passthruParams = "userid=" & MOODLE_USER_ID & "&courseid=" & Number.ToText(702),
    passthruParams = "userid=" & MOODLE_USER_ID,

    #"Get Webservice Response" =
                MOODLE_SVC_URL
                & "&wstoken=" & MOODLE_KEY
                // & "&wsfunction=" & "gradereport_user_get_grade_items"
                & "&wsfunction=" & "core_enrol_get_users_courses"
                & "&" & passthruParams,

    // Make Request to Moodle Web Service
    WebsvcResponse = Json.Document(Web.Contents(#"Get Webservice Response")),
    #"Converted to Table" = Table.FromList(WebsvcResponse, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "A"}}),
    #"Expanded A" = Table.ExpandRecordColumn(#"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"})
in
    #"Expanded A"

// MOODLE_KEY_FUNCTION
let
    Source = "",
    Custom1 = ""
in
    Custom1

// zzz-source-courses-raw
let
    // zzz-source-get_users_courses
    // load response from web service.
    // The `Assignment` table then references this and expands as needed.

    RemoteData = AskMoodleFor("core_enrol_get_users_courses", "userid=" & MOODLE_USER_ID),

    // Convert List to Table by applying the optional
    // splitting function, splitter, to each item in the list.
    // https://docs.microsoft.com/en-us/powerquery-m/table-fromlist
    Source = Table.FromList(
        RemoteData,
        Splitter.SplitByNothing(),
        null,
        null,
        ExtraValues.Error
    ),

    #"Renamed Columns" = Table.RenameColumns(
        Source,
        {
            {
                "Column1",
                "Courses"
            }
        }
    ),

    #"Expanded Courses" = Table.ExpandRecordColumn(

            #"Renamed Columns",
            "Courses",
            {
                "id",
                "displayname",
                "lastaccess",
                "progress",
                "isfavourite",
                "completed",
                "startdate",
                "enddate",
                "summary",
                "category",
                "format",
                "enablecompletion",
                "completionhascriteria",
                "completionusertracked",
                "marker",
                "overviewfiles"
            },

            {
                "C.id",
                "C.name",
                "C.lastaccess",
                "C.progress",
                "C.isfavourite",
                "C.completed",
                "C.startdate",
                "C.enddate",
                "C.summary",
                "C.category",
                "C.format",
                "C.enablecompletion",
                "C.completionhascriteria",
                "C.completionusertracked",
                "C.marker",
                "C.overviewfiles"
            }
    )
in
    #"Expanded Courses"

// debug AskMoodleForTable
let
    Source = AskMoodleFor("gradereport_user_get_grade_items", "userid=12345&courseid=123")
in
    Source

// debug_AskMoodleForGradebooks
let
    passthruParams = "userid=" & MOODLE_USER_ID & "&courseid=" & Number.ToText(123),

    #"Get Webservice Response" =
                        MOODLE_SVC_URL
                        & "&wsfunction=" & "gradereport_user_get_grade_items"
                        & "&wstoken=" & MOODLE_KEY
                        & "&" & passthruParams,

    // Make Request to Moodle Web Service
    WebsvcResponse = Json.Document(Web.Contents(#"Get Webservice Response")),
    // Make Request to Moodle Web Service
    usergrades = WebsvcResponse[usergrades]
in
    usergrades

// Query1
let
    Source = AskMoodleFor("mod_assign_get_assignments")
in
    Source

// debug AskMoodleForAssignments
let
    Source = AskMoodleFor("mod_assign_get_assignments")
    // , "userid=12345&courseid=702")
in
    Source

// debug_AskMoodleForAssignments (2)
let
    //
    // zzz-source-assignments
    // Request Assignments from Moodle using `mod_assign_get_assignments`.
    //
    // @since 2021-


    Source = AskMoodleFor("mod_assign_get_assignments"),

    // #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    // #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "A"}}),
    // #"Expanded A" = Table.ExpandRecordColumn(#"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"})

    Final = Source
in
   Source
