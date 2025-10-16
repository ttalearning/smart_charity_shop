import 'package:flutter/material.dart';
import 'package:smart_charity_shop/theme/app_colors.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';

/// =======================
/// BUTTONS
/// =======================

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final FormFieldValidator<String>? validator;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label, style: AppTextStyles.button),
              ],
            ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.button),
            ],
          ),
        ),
      ),
    );
  }
}

class OutlineButtonX extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const OutlineButtonX({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;

  const IconButtonCircle({
    super.key,
    required this.icon,
    this.onTap,
    this.bg = const Color(0xFFF1F5F9),
    this.fg = const Color(0xFF0E141B),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: fg),
        ),
      ),
    );
  }
}

/// =======================
/// CHIPS & HEADERS
/// =======================

class PillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const PillChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.surfaceAlt,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: AppTextStyles.chip.copyWith(
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h2),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: AppTextStyles.caption),
              ],
            ],
          ),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('Xem tất cả')),
      ],
    );
  }
}

/// =======================
/// INPUTS
/// =======================

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? prefix;
  final Widget? suffix;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}

class SearchBarX extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;

  const SearchBarX({
    super.key,
    this.hint = 'Tìm kiếm sản phẩm, chiến dịch…',
    this.onChanged,
    this.onClear,
    this.onSubmit,
  });

  @override
  State<SearchBarX> createState() => _SearchBarXState();
}

class _SearchBarXState extends State<SearchBarX> {
  final _c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _c,
      hint: widget.hint,
      prefix: const Icon(Icons.search),
      suffix: _c.text.isNotEmpty
          ? IconButtonCircle(
              icon: Icons.close_rounded,
              onTap: () {
                _c.clear();
                widget.onClear?.call();
                setState(() {});
              },
            )
          : null,
    );
  }
}

/// =======================
/// CARDS
/// =======================

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? location;
  final String? priceText; // "Miễn phí" hoặc "199K gây quỹ"
  final VoidCallback? onTap;
  final List<Widget>? tags;

  const ProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.location,
    this.priceText,
    this.onTap,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (location != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location!,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (priceText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.blueInfoGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(priceText!, style: AppTextStyles.button),
                        ),
                      const Spacer(),
                      if (tags != null) ...tags!,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignCard extends StatelessWidget {
  final String title;
  final String coverUrl;
  final String org;
  final double progress; // 0..1
  final String raisedText; // "120tr / 200tr"
  final VoidCallback? onTap;

  const CampaignCard({
    super.key,
    required this.title,
    required this.coverUrl,
    required this.org,
    required this.progress,
    required this.raisedText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(coverUrl, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(org, style: AppTextStyles.caption),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress.clamp(0, 1),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: AppColors.surfaceAlt,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(raisedText, style: AppTextStyles.number),
                      const Spacer(),
                      PrimaryButton(
                        label: 'Ủng hộ',
                        onPressed: onTap,
                        icon: Icons.favorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// INFO & MISC
/// =======================

class InfoStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const InfoStat({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.18),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBarX extends StatelessWidget {
  final double value; // 0..1
  final String? labelLeft;
  final String? labelRight;

  const ProgressBarX({
    super.key,
    required this.value,
    this.labelLeft,
    this.labelRight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (labelLeft != null || labelRight != null)
          Row(
            children: [
              if (labelLeft != null)
                Text(labelLeft!, style: AppTextStyles.caption),
              const Spacer(),
              if (labelRight != null)
                Text(labelRight!, style: AppTextStyles.caption),
            ],
          ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: 10,
            backgroundColor: AppColors.surfaceAlt,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating; // 0..5
  final int max;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.max = 5,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    return Row(
      children: List.generate(max, (i) {
        if (i < full)
          return Icon(Icons.star_rounded, color: AppColors.warning, size: size);
        if (i == full && hasHalf)
          return Icon(
            Icons.star_half_rounded,
            color: AppColors.warning,
            size: size,
          );
        return Icon(
          Icons.star_border_rounded,
          color: AppColors.warning,
          size: size,
        );
      }),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? action;

  const EmptyState({super.key, required this.title, this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_rounded, size: 64, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// =======================
/// LAYOUT
/// =======================

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minTileWidth;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minTileWidth = 160,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = (c.maxWidth / (minTileWidth + spacing)).floor().clamp(
          1,
          6,
        );
        return GridView.count(
          crossAxisCount: cols,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

/// =======================
/// NAV & FILTERS
/// =======================

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.surface,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_rounded),
          label: 'Chợ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Chiến dịch',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Tôi'),
      ],
    );
  }
}

class FilterChipsRow extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FilterChipsRow({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => PillChip(
          label: items[i],
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: items.length,
      ),
    );
  }
}
