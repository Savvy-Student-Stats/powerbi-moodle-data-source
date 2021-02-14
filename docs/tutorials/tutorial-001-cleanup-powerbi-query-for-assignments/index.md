# Formatting Power BI's Generated Code

This started off as a part of `tips-for-coding.md`  
as `Tip-001: Formatting Power BI's Lists`. 

It quickly grew.

There is this document, and associated git branches to go with it.

----

## Tip-001: Formatting Power BI's Lists

Lists, such as those generated from renaming a column, are all on one line.
That's very gross and difficult to understand.



## Example: `zzz-source-assignments`

To view in Power BI:

1. Open the report (`[school-stats-moodle.pbix](school-stats-moodle.pbix)`).

The source `"Power Query / M"`, ~~which I'll refer to as "Power Query"~~,  
is in the file [`powerbi-src/zzz-source-assignments.pq`](../../../powerbi-src/zzz-source-assignments.pq).

----

### `v1`: Power Query Editor (default)

This is what `Power BI` generates when you go through the `Power Query Editor`.
We can, and will, do much better.

```m
1: let
2:     Source = AskMoodleFor("mod_assign_get_assignments"),
3: 
4:     #"Converted to Table" = Table.FromList(RemoteDataTable[courses], Splitter.SplitByNothing(), null, null, ExtraValues.Error),
5:     #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "A"}}),
6:     #"Expanded A" = Table.ExpandRecordColumn(#"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"})
7: in
8:     #"Expanded A"
```

See git commit `a9f590e35cc6e1f3634d105ea03ff5e87da2886e`.

----

### `v2`: Cleaned Up a Bit, Added JSDoc Style Comments

```m
01: let
02:     //
03:     // zzz-source-assignments
04:     // Request Assignments from Moodle using `mod_assign_get_assignments`.
05:     //
06:     // @since  2021-02-12
07:     // @author code@sqrl.ca
08:     //
09: 
10:     Source = AskMoodleFor("mod_assign_get_assignments"),
11: 
12:     // Just grab the `courses` property and ignore the `warnings` one the web service returns for Assignments and Courses.
13:     // Is it just Grades that doesn't return the warnings property?
14:     // TODO: Find out if `warnings` is only returned when there are warnins, and if that means the responses could change,
15:     // which would be weird.
16:     #"Converted to Table" = Table.FromList(
17:         Source[courses],
18:         Splitter.SplitByNothing(),
19:         null,
20:         null,
21:         ExtraValues.Error
22:     ),
23:     #"Renamed Columns" = Table.RenameColumns(
24:         #"Converted to Table",{{"Column1", "A"}}
25:     ),
26:     #"Expanded A" = Table.ExpandRecordColumn(
27:         #"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"}
28:     )
29: in
30:     #"Expanded A"
31: 
```

See git commit `34e997b38bfcb0df46b5fa44a8fbc0d6c317d9e0`

> 34e997b - refactor(assignments): Improve default Power BI code for tutorial-001 (v2)

----

## v3: Cleaned up a bit more
```m
01: let
02:     //
03:     // zzz-source-assignments
04:     // Request Assignments from Moodle using `mod_assign_get_assignments`.
05:     //
06:     // @since  2021-02-12
07:     // @author code@sqrl.ca
08:     //
09: 
10:     Source = AskMoodleFor("mod_assign_get_assignments"),
11: 
12:     // WARNING:
13:     // Just grab the `courses` property.
14:     // Ignore the `warnings` property the web service returns for `Assignments` and `Courses`.
15:     // Is it just Grades that doesn't return the warnings property?
16:     // TODO: Find out if the `warnings` property is only returned when there are warnings.
17:     //       Does that mean the responses could change?
18:     //       That would be weird, unusual to break the response contract like that.
19:     //       No way would it do that...but stil...just double check in `Postman`.
20:     //
21:     CoursesList = Source[courses],
22: 
23:     #"Converted to Table" = Table.FromList(
24:         CoursesList,
25:         Splitter.SplitByNothing(),
26:         null,
27:         null,
28:         ExtraValues.Error
29:     ),
30:     #"Renamed Columns" = Table.RenameColumns(
31:         #"Converted to Table",{{"Column1", "A"}}
32:     ),
33:     #"Expanded A" = Table.ExpandRecordColumn(
34:         #"Renamed Columns", "A", {"id", "shortname", "fullname", "displayname", "enrolledusercount", "idnumber", "visible", "summary", "summaryformat", "format", "showgrades", "lang", "enablecompletion", "completionhascriteria", "completionusertracked", "category", "progress", "completed", "startdate", "enddate", "marker", "lastaccess", "isfavourite", "hidden", "overviewfiles"}, {"A.id", "A.shortname", "A.fullname", "A.displayname", "A.enrolledusercount", "A.idnumber", "A.visible", "A.summary", "A.summaryformat", "A.format", "A.showgrades", "A.lang", "A.enablecompletion", "A.completionhascriteria", "A.completionusertracked", "A.category", "A.progress", "A.completed", "A.startdate", "A.enddate", "A.marker", "A.lastaccess", "A.isfavourite", "A.hidden", "A.overviewfiles"}
35:     )
36: in
37:     #"Expanded A"
38: 
```

See git commit `c251c3fe3d18fdf2c96b9175ac324b0081a39bb4`

> c251c3f - refactor(assignments): Improve default Power BI code for tutorial-001 (v3) 


----
/end/done/goodbye/
