let
    // zzz-source-get_users_courses
    // load response from web service.
    // The `Assignment` table then references this and expands as needed.

    //
    // @since 2021-

    RemoteDataTable = AskMoodleForTable("core_enrol_get_users_courses", "userid=" & MOODLE_USER_ID),
    #"Renamed Columns" = Table.RenameColumns(
        RemoteDataTable,
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
