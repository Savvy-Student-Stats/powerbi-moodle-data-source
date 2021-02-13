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
    )

    // ADD DATE COLUMNS

in
    #"Removed Other Columns"

