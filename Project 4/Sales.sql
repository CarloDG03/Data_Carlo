-- Overview of the data
Select * from PortfolioProject..sales_data_sample


-- Distinct values

Select distinct( status) from PortfolioProject..sales_data_sample
select distinct (year_id) from PortfolioProject..sales_data_sample
select distinct productline from PortfolioProject..sales_data_sample
select distinct country from PortfolioProject..sales_data_sample
select distinct dealsize from PortfolioProject..sales_data_sample
select distinct territory from PortfolioProject..sales_data_sample

-- Analysing

Select
Productline, sum(sales) as Revenue
from PortfolioProject..sales_data_sample
group by productline
order by Revenue desc


Select
Year_ID, sum(Sales) as Revenue
from PortfolioProject..sales_data_sample
group by year_id
order by Revenue desc

-- Why is 2005 revenue so small
Select distinct month_id from PortfolioProject..sales_data_sample
where year_id = 2005

Select
dealsize , sum(sales) as revenue
from PortfolioProject..sales_data_sample
group by dealsize
order by revenue desc

-- what was the best month for revenue in a specfic year?

Select 
month_id, sum(sales) as revenue,  count(ordernumber) as Frequency
from PortfolioProject..sales_data_sample
where year_id = 2003
group by month_id
order by revenue desc

-- what was the most products sold in november?
Select 
month_id, sum(sales) as revenue,  count(ordernumber) as Frequency, productline
from PortfolioProject..sales_data_sample
where year_id = 2003 and month_id = 11
group by month_id , productline
order by revenue desc

-- Who is our best customer?
-- Using RFM

Drop table if exists #rfm 
;with rfm as
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(orderdate) from PortfolioProject..sales_data_sample) as max_order_date,
		Datediff(DD,max(ORDERDATE),(select max(orderdate) from PortfolioProject..sales_data_sample)) recency
from PortfolioProject..sales_data_sample
group by customername
),

rfm_calc as
(
select r.*,
	NTILE(4) over (order by	recency desc) as rfm_recency,
	NTILE(4) over (order by	frequency) as rfm_frequency,
	NTILE(4) over (order by	avgmonetaryvalue) as rfm_monetary
	
from rfm r

)
select c.*

from rfm_calc c



-- What products are most often sold together?
select ordernumber, STUFF( 


(select ',' +  PRODUCTCODE
from PortfolioProject..sales_data_sample p
where ORDERNUMBER in
	(

	select ordernumber
	from(
		Select ORDERNUMBER, count(*) rn
		from PortfolioProject..sales_data_sample as p 
		where status = 'shipped'
		group by ORDERNUMBER
) m
where rn = 3
)
	and p.ORDERNUMBER = s.ORDERNUMBER
	for xml path('')), 1,1,'') ProductCodes

from PortfolioProject..sales_data_sample as s
order by 2 desc