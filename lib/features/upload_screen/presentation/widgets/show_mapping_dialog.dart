import 'package:flutter/material.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/create_template_final_dialog.dart';

class CreateTemplateDialog extends StatefulWidget {
  const CreateTemplateDialog({super.key});

  @override
  State<CreateTemplateDialog> createState() => _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends State<CreateTemplateDialog> {
  // القوائم المتاحة والمختارة
  List<String> availableItems = [
     "مبلغ الفاتورة",
  "الوحدة المالية",
  "مجموعات العروض الترويجية",
  "طريقة الدفع",
  "المخزن",
  "مجموعات المخازن",
  "رقم المنطقة للمخزن",
  "نوع العميل",
  "مجموعة العميل",
  "درجة العميل",
  "نشاط العميل",
  "تصنيف العميل",
  "رقم العميل",
  "عملاء نقاطي",
  ];

  List<String> selectedItems = [];

  void _addItem(String item) {
    setState(() {
      if (!selectedItems.contains(item)) {
        selectedItems.add(item);
        availableItems.remove(item);
      }
    });
  }

  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
      if (!availableItems.contains(item)) {
        availableItems.add(item);
        availableItems.sort();
      }
    });
  }

  void _removeAllItems() {
    setState(() {
      for (var item in selectedItems) {
        if (!availableItems.contains(item)) {
          availableItems.add(item);
        }
      }
      selectedItems.clear();
      availableItems.sort();
    });
  }

  void _addAllItems() {
    setState(() {
      selectedItems.addAll(availableItems);
      availableItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: const Color(0xffF9F9F9),
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 850,
          height: 550,
          child: Column(
            children: [
              // ====== العنوان العلوي للديالوج ======
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xffF9F9F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "إنشاء قالب جديد",
                        style: AppTextStyles.styleRegular14(context, color: Colors.black87),
                      ),
                      InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: kGrayIX,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: kTextFiledColor,
                                size: 12,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              

              // ====== المحتوى الرئيسي (البيانات المتاحة والمختارة) ======
              Expanded(
                child: Row(
                  children: [
                    // القسم الأيمن - البيانات المتاحة
                    Expanded(
                      child: _buildSection(
                        title: "البيانات المتاحة",
                        actionText: "إضافة الكل",
                        actionColor: const Color(0xff0C69C0),
                        items: availableItems,
                        isRight: true,
                        onItemTap: _addItem,
                        onActionTap: _addAllItems,
                      ),
                    ),

                    // القسم الأيسر - البيانات المختارة
                    Expanded(
                      child: _buildSection(
                        title: "البيانات المختارة",
                        actionText: "حذف الكل",
                        actionColor: const Color(0xff0C69C0),
                        items: selectedItems,
                        isRight: false,
                        onItemTap: _removeItem,
                        onActionTap: _removeAllItems,
                      ),
                    ),
                  ],
                ),
              ),

              // ====== الأزرار السفلية ======
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  color: const Color(0xffF9F9F9),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0C69C0),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // إغلاق الديالوج الحالي
                        showDialog(
                          context: context,
                          builder: (context) => const CreateTemplateFinalDialog(),);
                      },
                      icon: const Icon(Icons.check, color: Colors.white, size: 20),
                      label: Text(
                        "تنفيذ",
                        style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff819AA7),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      label: Text(
                        "إلغاء",
                        style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====== ويدجت عامة للأقسام (البيانات المتاحة والمختارة) ======
  Widget _buildSection({
  required String title,
  required String actionText,
  required Color actionColor,
  required List<String> items,
  required bool isRight,
  required Function(String) onItemTap,
  required VoidCallback onActionTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ===== العنوان وزر الأكشن فوق =====
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.styleLight12(context,
                  color: Colors.black, fontSize: 15),
            ),
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: AppTextStyles.styleLight12(context,
                    color: actionColor, fontSize: 15),
              ),
            ),
          ],
        ),
      ),

      // ===== الكونتينر فيه العناصر فقط =====
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            itemCount: items.length,
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: isRight
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("${index + 1}",
                                  style: AppTextStyles.styleLight12(context,
                                      color: Colors.black, fontSize: 15)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(items[index],
                                    style: AppTextStyles.styleLight12(context,
                                        color: Colors.black, fontSize: 15)),
                              ),
                              GestureDetector(
                                onTap: () => onItemTap(items[index]),
                                child: const Icon(Icons.add,
                                    color: Color(0xff474747), size: 24),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xffE9E9E9)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text("${index + 1}",
                                  style: AppTextStyles.styleLight12(context,
                                      color: Colors.black, fontSize: 15)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(items[index],
                                    style: AppTextStyles.styleLight12(context,
                                        color: Colors.black, fontSize: 15)),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => onItemTap(items[index]),
                                child: const Icon(Icons.delete,
                                    color: Color(0xff474747), size: 24),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

}