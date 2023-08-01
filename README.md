# Avatars

Project with Combine, UIKit and MVVM architecture

This simple app consists of two screens and includes basic concepts that are common usecases for using reactive programming.

First screen populates a list of Github users with their Avatars.

Second screen presents details of the user data from Github API.


##Set up

To run the app clone this repository and open .xcodeproj file.


##Architecture Description

Here MVVM architecture is chosen.

ListView - Contains two different entities - ListView and AvatarCells


###For ListView

ListViewController(View), ListViewModel(ViewModel), GitUser(Model) are taken as Maincontroller class components.

Here Combine Framework is used to demonstrate the data bindings and swiftness of loading capabilities. 


###For AvatarCell

AvatarCell(View), AvatarCellViewModel(ViewModel), GitUser(Model) are considered as custom cell class components.

It is necessary to cache the image data with the github id for each and every Avatar cell to avoid requesting the image from URL everytime.


###For DetailsView

DetailsViewController(View), DetailsViewModel(ViewModel) and {GitUser, Repo & Gist}(Models) are taken as the detailed class components.
