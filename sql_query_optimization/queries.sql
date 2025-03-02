-- total-cost: 151.92
-- total-time: 0.451, 0.269

select d.id,
       COUNT(t.id)         as total_tasks_amount,
       sum(t.story_points) as total_story_points
from developers d
         join tasks t on d.id = t.developer_id
         join specialties s on s.id = d.specialty_id
where extract(month from created_at) = 1
group by (d.id)
having sum(t.story_points) < 5
order by d.last_name;

-- first optimization:
-- total-cost: 129.68
-- total-time: 0.282, 0.166

SELECT d.id,
       COUNT(t.id)         AS total_tasks_amount,
       SUM(t.story_points) AS total_story_points
FROM developers d
         LEFT JOIN tasks t ON d.id = t.developer_id AND EXTRACT(MONTH FROM created_at) = 1
GROUP BY d.id
HAVING SUM(t.story_points) < 5
ORDER BY d.id;

-- second optimization, add idx
create index idx_tasks_developer_id on tasks (developer_id);
create index idx_tasks_created_at on tasks (created_at);

-- third optimization, searchable and non-searchable arguments
-- postgres для этого метода EXTRACT(MONTH FROM created_at) = 1 не может использовать индексы
-- потому что индекс был создан для изначальных значений а не для производного значения
-- total-cost: 37.41
-- total-time: 0.158, 0.134, 0.061

SELECT d.id,
       COUNT(t.id)         AS total_tasks_amount,
       SUM(t.story_points) AS total_story_points
FROM developers d
         LEFT JOIN tasks t ON d.id = t.developer_id
where created_at > '2023-01-01'
  AND created_at < '2023-02-01'
GROUP BY d.id
HAVING SUM(t.story_points) < 5
ORDER BY d.id;