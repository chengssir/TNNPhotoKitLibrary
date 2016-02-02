# TNNPhotoKitLibrary
随着iOS不断的升级，苹果这个不要脸的居然逐步的放弃了AssetsLibrary，提供给我们新的框架Photos（这是什么鬼?图片?）

因为框架的替换，苹果官方并没有提供我们AssetsLibrary被放弃方法的备用方案，由此我们需要去在项目集成Photos，下面我们来分析下：


#AssetsLibrary：

ALASSetsGroupType: 类型
ALAssetsGroupLibrary：从iTunes 来的相册内容（如本身自带的向日葵照片）。
ALAssetsGroupAlbum：设备自身产生或从iTunes同步来的照片，但是不包括照片流跟分享流中的照片。(例如从各个软件中保存下来的图片)ALAssetsGroupEvent 相机接口事件产生的相册
ALAssetsGroupFaces 脸部相册（具体不清楚）
ALAssetsGroupSavedPhotos 相机胶卷照片
ALAssetsGroupPhotoStream 照片流
ALAssetsGroupAll 除了ALAssetsGroupLibrary上面所的内容。


#Photos：

    PHAssetCollectionSubtypeAlbumRegular          //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
    PHAssetCollectionSubtypeAlbumSyncedEvent  //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
    PHAssetCollectionSubtypeAlbumSyncedFaces  //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
    PHAssetCollectionSubtypeAlbumSyncedAlbum  //做了 AlbumSyncedEvent 应该做的事
    PHAssetCollectionSubtypeAlbumImported            //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
    PHAssetCollectionSubtypeAlbumMyPhotoStream //用户的 iCloud 照片流
    PHAssetCollectionSubtypeAlbumCloudShared      //用户使用 iCloud 共享的相册
    PHAssetCollectionSubtypeSmartAlbumGeneric      //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
    PHAssetCollectionSubtypeSmartAlbumPanoramas      //相机拍摄的全景照片
    PHAssetCollectionSubtypeSmartAlbumVideos      //相机拍摄的视频
    PHAssetCollectionSubtypeSmartAlbumFavorites      //收藏文件夹
    PHAssetCollectionSubtypeSmartAlbumTimelapses      //延时视频文件夹，同时也会出现在视频文件夹中
    PHAssetCollectionSubtypeSmartAlbumAllHidden      //包含隐藏照片或视频的文件夹
    PHAssetCollectionSubtypeSmartAlbumRecentlyAdded      //相机近期拍摄的照片或视频
    PHAssetCollectionSubtypeSmartAlbumBursts           //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
    PHAssetCollectionSubtypeSmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。不过我的 iPad mini 不支持，没法验证。
    PHAssetCollectionSubtypeSmartAlbumUserLibrary      //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
    PHAssetCollectionSubtypeAny                               //包含所有类型



   # AssetsLibrary获取文件夹（其中一种类型）
    [self.imagePickerController.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                                            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

    } failureBlock:^(NSError *error) {

    }];
    # 获取图片
  [ALAssetsGroup  enumerateAssetsUsingBlock:
  [ALAssetsGroup  enumerateAssetsAtIndexes:




Photos：
PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];

PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];


PHAssetCollection 文件夹

[PHFetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {

}];
获取图片

[[PHImageManager defaultManager] requestImageForAsset:fetchResult[1]
                                targetSize:CGSizeScale(cell.imageView3.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView3.image = result;
                                 }
                             }];
