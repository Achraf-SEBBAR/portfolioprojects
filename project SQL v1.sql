select *
from SQLDATACLEANING.dbo.Housing

select saledate
from SQLDATACLEANING.dbo.Housing

alter table Housing
add convertsaledate date;

update SQLDATACLEANING.dbo.Housing
set convertsaledate = convert(date,saledate)

select convertsaledate from SQLDATACLEANING.dbo.Housing

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from SQLDATACLEANING.dbo.Housing a
join SQLDATACLEANING.dbo.Housing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  update a
  set a.PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  from SQLDATACLEANING.dbo.Housing a
  join SQLDATACLEANING.dbo.Housing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ] 
  where a.PropertyAddress is null

 
 --breaking out address into colums( adress, city, state)
  
  select PropertyAddress
  from SQLDATACLEANING.dbo.Housing hous

  select
  SUBSTRING(PropertyAddress,1 , CHARINDEX(',', PropertyAddress) -1) as adress ,
  SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as adress
  from SQLDATACLEANING.dbo.Housing hous
  

  alter table SQLDATACLEANING.dbo.Housing
  add Propertysplitadress nvarchar(200)

  update SQLDATACLEANING.dbo.Housing 
  set Propertysplitadress = SUBSTRING(PropertyAddress,1 , CHARINDEX(',', PropertyAddress) -1)

  alter table SQLDATACLEANING.dbo.Housing
  add Propertysplitcity nvarchar(200)

  update SQLDATACLEANING.dbo.Housing
  set Propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


  select *
  from SQLDATACLEANING.dbo.Housing

  select 
  PARSENAME(replace(owneraddress,',','.'), 3)
  ,PARSENAME(replace(owneraddress,',','.'), 2)
  ,PARSENAME(replace(owneraddress,',','.'), 1)
  from SQLDATACLEANING.dbo.Housing

  alter table SQLDATACLEANING.dbo.Housing
  add splitowneradress nvarchar(200)
  
  update SQLDATACLEANING.dbo.Housing
  set splitowneradress = PARSENAME(replace(owneraddress,',','.'), 3)

  alter table SQLDATACLEANING.dbo.Housing
  add ownerrrtadress nvarchar(200)

  update SQLDATACLEANING.dbo.Housing 
  set ownerrrtadress = PARSENAME(replace(owneraddress,',','.'), 2)

  alter table SQLDATACLEANING.dbo.Housing
  add adress_TN nvarchar(200)

  update SQLDATACLEANING.dbo.Housing
  set adress_TN = PARSENAME(replace(owneraddress,',','.'), 1)

  select *
  from SQLDATACLEANING.dbo.Housing

  select distinct (soldasvacant)
  from SQLDATACLEANING.dbo.Housing

  select distinct (soldasvacant), count(soldasvacant)
  from SQLDATACLEANING.dbo.Housing
  group by soldasvacant
  order by 2


  select soldasvacant
  ,CASE when soldasvacant = 'Y' then 'Yes'
       when soldasvacant = 'N' then 'No'
	   else soldasvacant
       END
  from SQLDATACLEANING.dbo.Housing

  update SQLDATACLEANING.dbo.Housing
  set SoldAsVacant = CASE when soldasvacant = 'Y' then 'Yes'
       when soldasvacant = 'N' then 'No'
	   else soldasvacant
       END

  -- Remove duplicate

  with row_numCTE as
  (
  select *,
      ROW_NUMBER() over(
	            partition by parcelID,
				             propertyaddress,
							 saledate,
							 saleprice,
							 legalreference
							 order by 
							 uniqueID
							 )row_num
  from SQLDATACLEANING.dbo.Housing					        
  )
  

  delete
  from row_numCTE
  where row_num > 1
  -- Order by PropertyAddress


  -- Delete unused columns

  alter table SQLDATACLEANING.dbo.Housing
  drop column propertyaddress,saledate,owneraddress