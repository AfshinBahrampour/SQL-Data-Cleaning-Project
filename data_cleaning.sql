select *
from PortfolioProject..Naville

------------------------------------------------------------------------------
--standardlize date format
--CONVERT(Date, saledate) → This converts the saledate column into a pure DATE format (removes time part if present).

Alter table PortfolioProject..Naville
add saledateConverted Date;

update PortfolioProject..Naville
set saledateConverted = convert(Date,saledate)



select saledate, saledateconverted
from PortfolioProject..Naville


----------------------------------------------------------------------------
--Breaking out Address into individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..Naville

Select
substring(PropertyAddress, 1, CHARINDEX(',',Propertyaddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',Propertyaddress) +1, LEN(PropertyAddress)) as City
from PortfolioProject..Naville


Alter table PortfolioProject..Naville
add SplitedAddress nvarchar(255);

update PortfolioProject..Naville
set SplitedAddress = substring(PropertyAddress, 1, CHARINDEX(',',Propertyaddress) -1)



Alter table PortfolioProject..Naville
add SplitedCity Nvarchar(255);

update PortfolioProject..Naville
set SplitedCity = SUBSTRING(PropertyAddress, CHARINDEX(',',Propertyaddress) +1, LEN(PropertyAddress))


Select *
from PortfolioProject..Naville


-----------------------------------------------------------------------------------
--populate property address date

SELECT UniqueID, ParcelID, PropertyAddress
FROM PortfolioProject..Naville
--where PropertyAddress is null
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NAVILLE a
join PortfolioProject..Naville b
	on a.parcelID = b.parcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
set propertyaddress = isnull(a.PropertyAddress,b.PropertyAddress)
FROM NAVILLE a
join Naville b
	on a.parcelID = b.parcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



----------------------------------------------------------------------
--ownerAddress

Select
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject..Naville


Alter table PortfolioProject..Naville
add OwnerSplitedAddress Nvarchar(255);

update PortfolioProject..Naville
set OwnerSplitedAddress = parsename(replace(OwnerAddress, ',', '.'), 3)



Alter table PortfolioProject..Naville
add OwnerSplitedCity Nvarchar(255);

update PortfolioProject..Naville
set OwnerSplitedCity = parsename(replace(OwnerAddress, ',', '.'), 2)



Alter table PortfolioProject..Naville
add OwnerSplitedState Nvarchar(255);

update PortfolioProject..Naville
set OwnerSplitedState = parsename(replace(OwnerAddress, ',', '.'), 1)

Select *
from PortfolioProject..Naville



------------------------------------------------------------------------
--replace Y and N to Yes and No


Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject..Naville

Update PortfolioProject..Naville
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

Select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..Naville
group by SoldAsVacant
order by 2



----------------------------------------------------------------------
--delec duplicate Recors

with RowNumCTE as (
Select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 saledate,
				 saleprice,
				 legalReference
			     Order by
					UniqueID
					) row_num
from PortfolioProject..Naville
)
select *
from RowNumCTE
where row_num > 1


	


from PortfolioProject..Naville

select *
from PortfolioProject..Naville



-----------------------------------------------------------------
--delete unused colomns

Alter table PortfolioProject..Naville
Drop column propertyAddress, SaleDate, TaxDistrict, ownerAddress


