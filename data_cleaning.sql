--Populate property address data
select propertyA.ParcelID , propertyA.PropertyAddress, propertyB.ParcelID,propertyB.PropertyAddress, ISNULL(propertyA.PropertyAddress,propertyB.PropertyAddress)
from dataProject..NashvileHousing AS propertyA
JOIN dataProject..NashvileHousing AS propertyB
 ON propertyA.ParcelID = propertyB.ParcelID
 AND propertyA.[UniqueID ] <> propertyB.[UniqueID ]
Where propertyA.PropertyAddress is null

UPDATE propertyA
SET PropertyAddress = ISNULL(propertyA.PropertyAddress,propertyB.PropertyAddress)
from dataProject..NashvileHousing AS propertyA
JOIN dataProject..NashvileHousing AS propertyB
 ON propertyA.ParcelID = propertyB.ParcelID
 AND propertyA.[UniqueID ] <> propertyB.[UniqueID ]
Where propertyA.PropertyAddress is null



--Breaking Out Property Address into individual columns(Address, City)

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',', propertyAddress) -1), SUBSTRING(PropertyAddress,CHARINDEX(',', propertyAddress) +1, LEN(propertyAddress))
FROM dataProject..NashvileHousing

ALTER TABLE NashvileHousing
ADD PropertySplitAddress nvarchar(225);


ALTER TABLE NashvileHousing
ADD PropertySplitCity nvarchar(225);

UPDATE NashvileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', propertyAddress) -1)

UPDATE NashvileHousing
SET PropertySplitCity  =  SUBSTRING(PropertyAddress,CHARINDEX(',', propertyAddress) +1, LEN(propertyAddress))



--Breaking Out OwnerAddress into dividual columns(Address, City, State)

SELECT OwnerAddress ,  PARSENAME(REPLACE(OwnerAddress,',','.'), 3),  PARSENAME(REPLACE(OwnerAddress,',','.'), 2) , PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from dataProject..NashvileHousing

ALTER TABLE dataProject..NashvileHousing
ADD OwnerSplitAddress nvarchar(225);

UPDATE dataProject..NashvileHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE dataProject..NashvileHousing
ADD OwnerSplitCity nvarchar(225);

UPDATE dataProject..NashvileHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE dataProject..NashvileHousing
ADD OwnerSplitState nvarchar(225);

UPDATE dataProject..NashvileHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)



--Change Y AND N to Yes and No in "sold as vacant" field

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM dataProject..NashvileHousing
Group By (SoldAsVacant)
Order By 2


Select SoldAsVacant,
CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant= 'N' THEN 'No'
    ELSE SoldAsVacant 
END
From dataProject..NashvileHousing

Update  NashvileHousing
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant= 'N' THEN 'No'
    ELSE SoldAsVacant 
END
From dataProject..NashvileHousing



--Delete Duplicate
WITH RowNumCTE AS 
( select * , Row_Number () OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate, LegalReference ORDER BY UniqueID) AS rowNumber
from dataProject..NashvileHousing )
SELECT *
FROM RowNumCTE
Where rowNumber > 1



----Standardize date format

Select SaleDate , CONVERT(date, saleDate)
From dataProject..NashvileHousing

update NashvileHousing
set SaleDate = CONVERT(date, saleDate)
From dataProject..NashvileHousing

select *
from dataProject..NashvileHousing

ALTER TABLE NashvileHousing
ADD SaleDates date;

update NashvileHousing
set SaleDates = CONVERT(date, saleDate)
From dataProject..NashvileHousing




--DELECT COLUMNS

ALTER TABLE NashvileHousing
DROP COLUMN SaleDate, OwnerName, TaxDistrict, PropertyAddress;


SELECT *
FROM dataProject..NashvileHousing

