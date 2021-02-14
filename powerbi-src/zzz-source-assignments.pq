let
    //
    // zzz-source-assignments
    // Request Assignments from Moodle using `mod_assign_get_assignments`.
    //
    // @since  2021-02-12
    // @author code@sqrl.ca
    //

    Source = AskMoodleFor("mod_assign_get_assignments"),

    // WARNING:
    // Just grab the `courses` property.
    // Ignore the `warnings` property the web service returns for `Assignments` and `Courses`.
    // Is it just Grades that doesn't return the warnings property?
    // TODO: Find out if the `warnings` property is only returned when there are warnings.
    //       Does that mean the responses could change?
    //       That would be weird, unusual to break the response contract like that.
    //       No way would it do that...but stil...just double check in `Postman`.
    //
    CoursesList = Source[courses],

    #"Converted to Table" = Table.FromList(
        CoursesList,
        Splitter.SplitByNothing(),
        null,
        null,
        ExtraValues.Error
    ),
    #"Renamed Columns" = Table.RenameColumns(
        #"Converted to Table",{{"Column1", "A"}}
    ),
    #"Expanded A" = Table.ExpandRecordColumn(
        #"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"}
    )
in
    #"Expanded A"
