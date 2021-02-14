let
    //
    // zzz-source-assignments
    // Request Assignments from Moodle using `mod_assign_get_assignments`.
    //
    // @since  2021-02-12
    // @author code@sqrl.ca
    //

    Source = AskMoodleFor("mod_assign_get_assignments"),

    // Just grab the `courses` property and ignore the `warnings` one the web service returns for Assignments and Courses.
    // Is it just Grades that doesn't return the warnings property?
    // TODO: Find out if `warnings` is only returned when there are warnins, and if that means the responses could change,
    // which would be weird.
    #"Converted to Table" = Table.FromList(
        Source[courses],
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
