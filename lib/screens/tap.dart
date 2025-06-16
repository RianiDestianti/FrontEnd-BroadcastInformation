import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../models/model.dart';

class CategoryTapHandler {
  static void showCategoryDescription(
    BuildContext context,
    CategoryData category,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HomeStyles.borderRadiusXXLarge),
          ),
          backgroundColor:
              HomeStyles.white, 
          child: CategoryDescriptionPopup(
            category: category,
            description: category.description,
          ),
        );
      },
    );
  }

  static void showCategoryBottomSheet(
    BuildContext context,
    CategoryData category,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, 
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategoryBottomSheet(
          category: category,
          description: category.description,
        );
      },
    );
  }
}

class CategoryDescriptionPopup extends StatelessWidget {
  final CategoryData category;
  final String description;

  const CategoryDescriptionPopup({
    super.key,
    required this.category,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      decoration: BoxDecoration(
        color: HomeStyles.white, 
        borderRadius: BorderRadius.circular(HomeStyles.borderRadiusXXLarge),
      ),
      padding: const EdgeInsets.all(HomeStyles.paddingXXLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: HomeStyles.categoryCircleSize * 0.8,
                height: HomeStyles.categoryCircleSize * 0.8,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: HomeStyles.white,
                  size: HomeStyles.iconSizeLarge,
                ),
              ),
              const SizedBox(width: HomeStyles.spacingXXLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kategori', style: HomeStyles.filterLabel),
                    const SizedBox(height: HomeStyles.spacingSmall),
                    Text(
                      category.name,
                      style: HomeStyles.announcementTitle.copyWith(
                        color: category.color,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: HomeStyles.iconSizeMedium,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: HomeStyles.spacingXXXLarge),
          Container(height: 1, color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: HomeStyles.spacingXXXLarge),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi', style: HomeStyles.sectionTitle),
                  const SizedBox(height: HomeStyles.spacingXLarge),
                  Text(
                    description,
                    style: HomeStyles.announcementDescription.copyWith(
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: HomeStyles.spacingXXXLarge),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                foregroundColor: HomeStyles.white,
                padding: const EdgeInsets.symmetric(
                  vertical: HomeStyles.paddingXLarge,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    HomeStyles.borderRadiusLarge,
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                'Mengerti',
                style: HomeStyles.bannerTag.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBottomSheet extends StatelessWidget {
  final CategoryData category;
  final String description;

  const CategoryBottomSheet({
    super.key,
    required this.category,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: HomeStyles.white, 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(HomeStyles.borderRadiusXXLarge),
          topRight: Radius.circular(HomeStyles.borderRadiusXXLarge),
        ),
      ),
      padding: const EdgeInsets.all(HomeStyles.paddingXXLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: HomeStyles.spacingXXXLarge),
          Row(
            children: [
              Container(
                width: HomeStyles.categoryCircleSize,
                height: HomeStyles.categoryCircleSize,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: HomeStyles.white,
                  size: HomeStyles.iconSizeXLarge,
                ),
              ),
              const SizedBox(width: HomeStyles.spacingXXLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kategori', style: HomeStyles.filterLabel),
                    const SizedBox(height: HomeStyles.spacingSmall),
                    Text(
                      category.name,
                      style: HomeStyles.announcementTitle.copyWith(
                        color: category.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: HomeStyles.spacingXXXLarge),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(HomeStyles.paddingXXLarge),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(HomeStyles.borderRadiusLarge),
              border: Border.all(
                color: category.color.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: HomeStyles.iconSizeSmall,
                      color: category.color,
                    ),
                    const SizedBox(width: HomeStyles.spacingMedium),
                    Text(
                      'Deskripsi',
                      style: HomeStyles.categoryNameSelected.copyWith(
                        color: category.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HomeStyles.spacingXLarge),
                Text(
                  description,
                  style: HomeStyles.announcementDescription.copyWith(
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const SizedBox(height: HomeStyles.spacingXXXLarge),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                foregroundColor: HomeStyles.white,
                padding: const EdgeInsets.symmetric(
                  vertical: HomeStyles.paddingXLarge,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    HomeStyles.borderRadiusLarge,
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                'Mengerti',
                style: HomeStyles.bannerTag.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
