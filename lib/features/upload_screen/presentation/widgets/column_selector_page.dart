import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';

class ColumnSelectorPage extends StatefulWidget {
  final List<String> availableColumns;
  final Function(List<String>) onColumnsSelected;
  
  const ColumnSelectorPage({
    super.key,
    required this.availableColumns,
    required this.onColumnsSelected,
  });

  @override
  State<ColumnSelectorPage> createState() => _ColumnSelectorPageState();
}

class _ColumnSelectorPageState extends State<ColumnSelectorPage> {
  final List<String> _selectedColumns = [];

  @override
  void initState() {
    super.initState();
    // البدء بجميع الأعمدة متاحة
  }

  // Build a draggable list item
  Widget _draggableItem(String value, bool isSelected) {
    return Draggable<String>(
      data: value,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kCardGreenColor : kSkyDarkColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: _listTile(value, isSelected)),
      child: _listTile(value, isSelected),
    );
  }

  // Simple tile
  Widget _listTile(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? kCardGreenColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? kCardGreenColor : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          text,
          style: TextStyle(
            color: isSelected ? kCardGreenColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Icon(
          Icons.drag_handle,
          color: isSelected ? kCardGreenColor : Colors.grey,
        ),
      ),
    );
  }

  // DragTarget builder
  Widget _buildDroppableList({
    required String title,
    required List<String> items,
    required bool isSelectedList,
    required Color headerColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        isSelectedList ? 'اسحب الأعمدة هنا' : 'اسحب من هنا',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final item = items[idx];
                      return _draggableItem(item, isSelectedList);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: kTextColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'تحديد الأعمدة المراد عرضها',
            style: AppTextStyles.styleRegular16(context, color: kTextColor),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check, color: kCardGreenColor),
              onPressed: () {
                widget.onColumnsSelected(_selectedColumns);
                Navigator.pop(context);
              },
              tooltip: 'حفظ والعودة',
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instruction Text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    'اسحب الأعمدة من القائمة المتاحة إلى القائمة المحددة لإنشاء القالب',
                    style: AppTextStyles.styleRegular14(context, color: kTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Lists
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDroppableList(
                          title: 'الأعمدة المحددة',
                          items: _selectedColumns,
                          isSelectedList: true,
                          headerColor: kCardGreenColor,
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: _buildDroppableList(
                          title: 'الأعمدة المتاحة',
                          items: widget.availableColumns,
                          isSelectedList: false,
                          headerColor: kSkyDarkColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Save Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onColumnsSelected(_selectedColumns);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kCardGreenColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'حفظ والعودة',
                        style: AppTextStyles.styleLight14(context, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}