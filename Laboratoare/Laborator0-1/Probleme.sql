--1
select t.TITLE, count(tc.COPY_ID)
from TITLE t
join TITLE_COPY tc on t.TITLE_ID = tc.TITLE_ID
where lower(tc.STATUS) = 'available'
group by t.TITLE ;
--2
select m.FIRST_NAME, m.LAST_NAME, tc.TITLE_ID, count(*) as nr
from RENTAL r
join MEMBER m on r.MEMBER_ID = m.MEMBER_ID
join TITLE_COPY tc on r.TITLE_ID = tc.TITLE_ID and r.COPY_ID = tc.COPY_ID
group by m.FIRST_NAME, m.LAST_NAME, tc.TITLE_id
order by nr desc;
--3



