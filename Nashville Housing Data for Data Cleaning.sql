
------ Cleaning Data in SQL Queries

Select *
from PortfolioProject.dbo.NashvilleHousing

------ Standardize Date Format

Select SaleDateConverted, Convert(Date,Saledate)
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set Saledate = convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = convert(Date,SaleDate) 


------Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
-- Where property is not null
Order By ParcelID


Select a.ParcelID, a.propertyaddress, a.ParcelID, b.propertyaddress,
 isnull (a.propertyaddress,b.propertyaddress)
 from PortfolioProject.dbo.NashvilleHousing a
 Join PortfolioProject.dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
	  and a.[UniqueID ] <> b.[UniqueID ]
	  Where a.propertyaddress is null


Update a
Set PropertyAddress =  isnull (a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing a
 Join PortfolioProject.dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
	  and a.[UniqueID ] <> b.[UniqueID ]
	  Where a.propertyaddress is null


------Breaking out address into individual cloumns (Address,City,State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress in null
--Order by ParcelID



Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address,
       SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, lEN(PropertyAddress)) As Address
from PortfolioProject.dbo.NashvilleHousing



Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,
                           CHARINDEX(',',PropertyAddress)-1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,
                        CHARINDEX(',',PropertyAddress)+1, lEN(PropertyAddress)) 



Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',',','),3),
PARSENAME(Replace(OwnerAddress,',',','),2),
PARSENAME(Replace(OwnerAddress,',',','),1)
from PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',',','),3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',',','),2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',',','),1)


Select *
from PortfolioProject.dbo.NashvilleHousing


--------Change Y and N To Yes and No in 'Sold As Vacant' Field 

Select Distinct(SoldAsVacant), Count (SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y'Then 'Yes'
      When SoldAsVacant = 'N'Then 'No'
	  Else SoldAsVacant
	  End
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y'Then 'Yes'
      When SoldAsVacant = 'N'Then 'No'
	  Else SoldAsVacant
	  End

-----Remove Duplicates

With RowNumCTE As (
Select *,
       Row_Number()Over (
	   Partition by ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					Legalreference
					Order by
					UniqueID
					) row_num
from PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



-----Delete Unused Columns


Select *
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate










