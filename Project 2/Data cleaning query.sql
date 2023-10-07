-- Date Formatting

Select * From PortfolioProject.. Housing

Alter table Housing
ADD SaleDateConverted Date;

Update Housing
Set SaleDateConverted = Convert(Date,SaleDate)

Select Saledateconverted, Convert(Date,Saledate)
From PortfolioProject .. Housing

-- Populate Property Address data

Select  * --PropertyAddress
From PortfolioProject .. Housing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.. Housing a

JOIN PortfolioProject.. Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress =  ISNULL(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.. Housing a

JOIN PortfolioProject.. Housing b
	on a. ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Putting Address into Columns from property address

Select propertyaddress
From PortfolioProject..Housing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress))as Address
From PortfolioProject..Housing


Alter Table Housing
ADD PropertySplitAddress Nvarchar(300)

Update Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table Housing
ADD PropertySplitCity Nvarchar(300)

Update Housing
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress))

Select * from PortfolioProject .. Housing


-- Same procedure but using a different procedure for owner address
Select OwnerAddress
from PortfolioProject .. Housing


Select 
PARSENAME (REPLACE(OwnerAddress, ',' , '.' ),3)
 , PARSENAME (REPLACE(OwnerAddress, ',' , '.' ),2)
  , PARSENAME (REPLACE(OwnerAddress, ',' , '.' ),1)

from PortfolioProject .. Housing


Alter Table Housing
ADD OwnerSplitAddress Nvarchar(300)

Update Housing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',' , '.' ),3)

Alter Table Housing
ADD OwnerSplitCity Nvarchar(300)

Update Housing
SET  OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',' , '.' ),2)


Alter Table Housing
ADD OwnerSplitState Nvarchar(300)

Update Housing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',' , '.' ),1)

Select * from PortfolioProject.. Housing


-- Sold as Vacant 

Select Distinct (SoldAsVacant), Count(Soldasvacant)
From PortfolioProject.. Housing
Group by SoldAsVacant
Order by 2 


Select soldasvacant
, Case When SoldasVacant = 'Y' Then 'Yes'
	 When soldasvacant = 'N' then 'No'
	Else soldasvacant
	END
From PortfolioProject..Housing

Update Housing
Set SoldasVacant = Case When SoldasVacant = 'Y' Then 'Yes'
	 When soldasvacant = 'N' then 'No'
	Else soldasvacant
	END


-- Remove Duplicates


WITH RowNumCTE as(
Select *,
	ROW_NUMBER() Over(
	Partition BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
					) row_num
from PortfolioProject .. Housing

)
Select* from RowNumCTE  -- replacing select for delete to remove duplicates
Where row_num > 1



-- Removing unused columns.

Select * from PortfolioProject.. Housing

Alter table PortfolioProject.. Housing
Drop Column SaleDATE

