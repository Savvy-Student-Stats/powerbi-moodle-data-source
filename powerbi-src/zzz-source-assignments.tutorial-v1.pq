1: let
2:     Source = AskMoodleFor("mod_assign_get_assignments"),
3:
4:     #"Converted to Table" = Table.FromList(RemoteDataTable[courses], Splitter.SplitByNothing(), null, null, ExtraValues.Error),
5:     #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "A"}}),
6:     #"Expanded A" = Table.ExpandRecordColumn(#"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"})
7: in
8:     #"Expanded A"
