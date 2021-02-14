// zzz-source-gradereport_user_get_grade_items
// @since 2021-02-10

let
    Source = #"Source-get_users_courses",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Course.id", "Course.shortname"}),

    RemoteData = AskMoodleFor(
        "gradereport_user_get_grade_items",
        "userid=" & MOODLE_USER_ID
        & "&courseid=" [Course.id]
    ),
    #"Invoked Custom Function" = Table.AddColumn(
        #"Removed Other Columns", "GradeReport",
        each AskMoodleFor("gradereport_user_get_grade_items", "userid="REPLACE"&courseid=REPLACE")
    )
in
    #"Invoked Custom Function"


---

// Source-Gradebooks.dax
// @since 2021-0

let
    COURSE_IDS = { 780,671,673,684,702 },

    // thanks `#table` https://blog.crossjoin.co.uk/2016/06/03/creating-tables-in-power-bipower-query-m-code-using-table/
    SourceTable = #table({"G.courseId"}, { {780},{671},{673},{684},{702} }),
    #"Invoked Custom Function" = Table.AddColumn(SourceTable, "AskMoodleForGradebook", each AskMoodleForGradebookTable([courseid])),
    #"Expanded AskMoodleForGradebook" = Table.ExpandRecordColumn(#"Invoked Custom Function", "AskMoodleForGradebook", {"usergrades"}, {"usergrades"}),
    #"Expanded usergrades" = Table.ExpandListColumn(#"Expanded AskMoodleForGradebook", "usergrades"),
    #"Expanded usergrades1" = Table.ExpandRecordColumn(#"Expanded usergrades", "usergrades", {"courseid", "userid", "userfullname", "maxdepth", "gradeitems"}, {"courseid.1", "userid", "userfullname", "maxdepth", "gradeitems"}),
    #"Expanded gradeitems" = Table.ExpandListColumn(#"Expanded usergrades1", "gradeitems"),
    #"Expanded gradeitems1" = Table.ExpandRecordColumn(#"Expanded gradeitems", "gradeitems", {"id", "itemname", "itemtype", "itemmodule", "iteminstance", "itemnumber", "categoryid", "outcomeid", "scaleid", "locked", "graderaw", "gradedatesubmitted", "gradedategraded", "gradehiddenbydate", "gradeneedsupdate", "gradeishidden", "gradeislocked", "gradeisoverridden", "gradeformatted", "feedback", "feedbackformat", "cmid"}, {"gradeitems.id", "gradeitems.itemname", "gradeitems.itemtype", "gradeitems.itemmodule", "gradeitems.iteminstance", "gradeitems.itemnumber", "gradeitems.categoryid", "gradeitems.outcomeid", "gradeitems.scaleid", "gradeitems.locked", "gradeitems.graderaw", "gradeitems.gradedatesubmitted", "gradeitems.gradedategraded", "gradeitems.gradehiddenbydate", "gradeitems.gradeneedsupdate", "gradeitems.gradeishidden", "gradeitems.gradeislocked", "gradeitems.gradeisoverridden", "gradeitems.gradeformatted", "gradeitems.feedback", "gradeitems.feedbackformat", "gradeitems.cmid"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded gradeitems1",{"gradeitems.id", "gradeitems.itemname", "gradeitems.itemtype", "gradeitems.itemmodule", "gradeitems.iteminstance", "gradeitems.itemnumber", "gradeitems.categoryid", "gradeitems.outcomeid", "gradeitems.scaleid", "gradeitems.locked", "gradeitems.graderaw", "gradeitems.gradedatesubmitted", "gradeitems.gradedategraded", "gradeitems.gradehiddenbydate", "gradeitems.gradeneedsupdate", "gradeitems.gradeishidden", "gradeitems.gradeislocked", "gradeitems.gradeisoverridden", "gradeitems.gradeformatted", "gradeitems.feedback", "gradeitems.feedbackformat", "gradeitems.cmid", "courseid"})
in
    #"Removed Other Columns"
