import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7D562D);
    const Color primaryContainer = Color(0xFFD4A373);
    const Color backgroundColor = Color(0xFFFDF9F5);

    final filteredAsync = ref.watch(filteredCustomersProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('العملاء'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(backgroundColor: Color(0xFFE6E2DE), child: Icon(Icons.person, color: primaryColor)),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(customerSearchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث عن عميل...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF82756A)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(customerSearchQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF7F3EF),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),

              Expanded(
                child: filteredAsync.when(
                  data: (customers) {
                    if (customers.isEmpty) {
                      return Center(
                        child: Text(
                          _searchController.text.isNotEmpty
                              ? 'لا توجد نتائج للبحث.'
                              : 'لا يوجد عملاء مضافين.',
                        ),
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 100,
                            ),
                            itemCount: customers.length,
                            itemBuilder: (context, index) => _buildCustomerCard(context, customers[index]),
                          );
                        } else {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: customers.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildCustomerCard(context, customers[index]),
                            ),
                          );
                        }
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('خطأ في جلب البيانات: $err')),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/customers/add');
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('إضافة عميل جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        onTap: (index) {
          if (index == 0) context.go('/');
          else if (index == 1) context.go('/customers');
          else if (index == 2) context.go('/contracts');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'العملاء'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'العقود'),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, dynamic customer) {
    return InkWell(
      onTap: () => context.push('/customers/${customer.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: ListTile(
          leading: const Icon(Icons.chevron_left),
          title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(customer.phones.isNotEmpty ? customer.phones.first : 'بدون هاتف'),
          trailing: CircleAvatar(
            backgroundColor: const Color(0xFFFFDCBD),
            child: Text(customer.name.substring(0, 1), style: const TextStyle(color: Color(0xFF2C1600))),
          ),
        ),
      ),
    );
  }
}