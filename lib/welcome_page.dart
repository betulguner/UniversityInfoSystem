import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Map<String, int> campusCounts = {};
  Map<String, int> unitCounts = {};
  Map<String, int> usageCounts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoomData();
  }

  Future<void> fetchRoomData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('oda_kayitlari').get();

      final Map<String, int> countsCampus = {};
      final Map<String, int> countsUnit = {};
      final Map<String, int> countsUsage = {};

      for (var doc in snapshot.docs) {
        final kampus = (doc['kampus'] ?? '').toString().trim();
        final birim = (doc['kullananBirim'] ?? '').toString().trim();
        final kullanimAmaci = (doc['kullanimAmaci'] ?? '').toString().trim();

        if (kampus.isNotEmpty && kampus.toLowerCase() != 'bilinmiyor') {
          countsCampus[kampus] = (countsCampus[kampus] ?? 0) + 1;
        }

        if (birim.isNotEmpty && birim.toLowerCase() != 'bilinmiyor') {
          countsUnit[birim] = (countsUnit[birim] ?? 0) + 1;
        }

        if (kullanimAmaci.isNotEmpty &&
            kullanimAmaci.toLowerCase() != 'bilinmiyor') {
          countsUsage[kullanimAmaci] =
              (countsUsage[kullanimAmaci] ?? 0) + 1;
        }
      }

      setState(() {
        campusCounts = countsCampus;
        unitCounts = countsUnit;
        usageCounts = countsUsage;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Firestore veri çekme hatası: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildBarChart(String title, Map<String, int> data, Color barColor) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('$title verisi bulunamadı.')),
      );
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxCount = entries.first.value;
    final maxY = ((maxCount / 10).ceil()) * 10 + 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: entries.length * 60.0 + 50,
            child: BarChart(
              BarChartData(
                maxY: maxY.toDouble(),
                barGroups: entries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final count = entry.value.value.toDouble();
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count,
                        borderRadius: BorderRadius.circular(8),
                        color: barColor,
                        width: 22,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY.toDouble(),
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  );
                }).toList(),
                alignment: BarChartAlignment.center,
                groupsSpace: 30,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        if (value % 10 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 120,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < entries.length) {
                          return Transform.translate(
                            offset: const Offset(12, 12),
                            child: Transform.rotate(
                              angle: -1.2,
                              child: SizedBox(
                                width: 90,
                                child: Text(
                                  entries[index].key,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: Colors.grey.shade300, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHorizontalBarChartList(
      String title, Map<String, int> data, Color barColor) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('$title verisi bulunamadı.')),
      );
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxCount = entries.first.value;
    const maxBarLength = 250.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final birim = entries[index].key;
              final count = entries[index].value;
              final barWidth = (count / maxCount) * maxBarLength;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(
                        birim,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        Container(
                          width: maxBarLength,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        Container(
                          width: barWidth,
                          height: 22,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('ATAInsight',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[700],
        elevation: 3,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : campusCounts.isEmpty && unitCounts.isEmpty && usageCounts.isEmpty
              ? const Center(
                  child: Text('Kayıt bulunamadı.',
                      style: TextStyle(fontSize: 18)))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildBarChart(
                          'Kampüslere Göre Dağılım',
                          campusCounts,
                          Colors.blue.shade700,
                        ),
                        const SizedBox(height: 48),
                        buildHorizontalBarChartList(
                          'Birimlere Göre Dağılım',
                          unitCounts,
                          Colors.deepOrange.shade400,
                        ),
                        const SizedBox(height: 48),
                        buildHorizontalBarChartList(
                          'Kullanım Amacına Göre Dağılım',
                          usageCounts,
                          Colors.green.shade600,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.blue.shade700, width: 2),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              'Oda Kayıtlarını Gör',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}