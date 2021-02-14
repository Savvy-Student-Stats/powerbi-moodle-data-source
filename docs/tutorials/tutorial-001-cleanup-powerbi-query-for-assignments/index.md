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

