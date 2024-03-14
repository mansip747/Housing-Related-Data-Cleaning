
--cleaning data in SQL queries
Select *
from [Portfolio Project ]..NashvilleHousing

--standardize date format

Select SaleDateConverted, convert(date,SaleDate) 
from [Portfolio Project ]..NashvilleHousing

update [Portfolio Project ]..NashvilleHousing
set saledate = convert(date,SaleDate)

Alter table [Portfolio Project ]..NashvilleHousing
Add SaleDateConverted Date;

Update [Portfolio Project ]..NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)


--Populate property data

Select *
from [Portfolio Project ]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from [Portfolio Project ]..NashvilleHousing a
Join [Portfolio Project ]..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

Update a
Set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from [Portfolio Project ]..NashvilleHousing a
Join [Portfolio Project ]..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


--Breaking out address into Individual columns(address, city, state)

Select PropertyAddress
from [Portfolio Project ]..NashvilleHousing


Select substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1 ) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from [Portfolio Project ]..NashvilleHousing


Alter table [Portfolio Project ]..NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

update [Portfolio Project ]..NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1 )

Alter table [Portfolio Project ]..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project ]..NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
from  [Portfolio Project ]..NashvilleHousing

Select OwnerAddress
from  [Portfolio Project ]..NashvilleHousing

Select ParseName(Replace(OwnerAddress, ',' , '.'), 3),
ParseName(Replace(OwnerAddress, ',' , '.'), 2),
ParseName(Replace(OwnerAddress, ',' , '.'), 1)
from  [Portfolio Project ]..NashvilleHousing

Alter table [Portfolio Project ]..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

update [Portfolio Project ]..NashvilleHousing
set OwnerSplitAddress = ParseName(Replace(OwnerAddress, ',' , '.'), 3)

Alter table [Portfolio Project ]..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project ]..NashvilleHousing
set OwnerSplitCity = ParseName(Replace(OwnerAddress, ',' , '.'), 2)

Alter table [Portfolio Project ]..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

update [Portfolio Project ]..NashvilleHousing
set OwnerSplitAddress = ParseName(Replace(OwnerAddress, ',' , '.'), 1)


--change 'Y' and 'N' to 'Yes' and 'No' from "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Portfolio Project ]..NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from [Portfolio Project ]..NashvilleHousing


Update [Portfolio Project ]..NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end


--Remove Duplicates
With RowNumCTE As(
Select * ,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
				      UniqueID
					  )row_num        
from [Portfolio Project ]..NashvilleHousing
)
delete
from RowNumCTE
where row_num > 1


Select *
from  [Portfolio Project ]..NashvilleHousing





