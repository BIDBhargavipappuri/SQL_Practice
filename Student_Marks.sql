select * from  Students
select * from  Schools
select * from  Marks

/*List all students along with their school and the sum of their marks */ 

With T as
(
select student_id,sum(marks) as Total_marks
from Marks
group by student_id
)
select a.student_id,a.student_name,b.school_name,T.Total_marks
from Students a
left join Schools b on a.school_id = b. school_id
left join T on a.student_id = t.student_id