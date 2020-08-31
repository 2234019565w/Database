/*请编写一个MySQL存储过程`calc_student_stat`计算统计数据并输出到一个新表`student_stat`中。其中需要统计的数据有：

1. avg_score: 该科目平均分
2. score: 学生在该科目下的得分
3. total_score: 学生总分
4. score_rate: 该科目得分占总分的比例

除了上述统计字段，`student_stat`表还包含字段：`name` `teacher` `subject`.   
*/
DROP PROCEDURE
IF EXISTS calc_student_stat;

CREATE PROCEDURE calc_student_stat ()
BEGIN
	DROP TEMPORARY TABLE
IF EXISTS student_stat_1temp;

CREATE TEMPORARY TABLE student_stat_1temp AS SELECT
	s1.student_id,
	s1.subject_id,
	s1.score,
	s2.total_score,
	t3.avg_score,
	s1.score / s2.total_score AS score_rate
FROM
	score AS s1
LEFT JOIN (
	SELECT
		student_id,
		sum(score) AS total_score
	FROM
		score
	GROUP BY
		student_id
) AS s2 ON s1.student_id = s2.student_id
LEFT JOIN (
	SELECT
		subject_id,
		avg(score) AS avg_score
	FROM
		score
	GROUP BY
		subject_id
) AS s3 ON s1.subject_id = s3.subject_id;

DROP TABLE
IF EXISTS student_stat;

CREATE TABLE student_stat AS SELECT
	b. NAME,
	c. SUBJECT,
	c.teacher,
	a.score,
	a.total_score,
	a.avg_score,
	a.score_rate
FROM
	student_stat_1temp AS a
LEFT JOIN student AS b ON a.student_id = b.id
LEFT JOIN SUBJECT AS c ON a.subject_id = c.id;


END;

CALL calc_student_stat ();