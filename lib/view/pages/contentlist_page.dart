part of 'pages.dart';

class ContentListPage extends StatefulWidget {
  const ContentListPage({super.key});

  @override
  State<ContentListPage> createState() => _ContentListPageState();
}

class _ContentListPageState extends State<ContentListPage> {
  ContentViewModel contentViewModel = ContentViewModel();

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    var userData = await UserLocalStorage.getUserData();
    setState(() {
      userId = userData?.id;
    });
    if (userId != null) {
      print("USER ID: " + userId!);
      contentViewModel.getContentList(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Content",
          style: TextStyle(
            color: AppColors.textColor_0,
            fontFamily: 'Poppins',
            fontSize: 20,
          ),
        ),
      ),
      body: ChangeNotifierProvider<ContentViewModel>(
        create: (context) => contentViewModel,
        child: Consumer<ContentViewModel>(
          builder: (context, value, _) {
            switch (value.contentList.status) {
              case Status.loading:
                return Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor),
                );
              case Status.error:
                return Center(
                  child: Text(
                    'Failed to load content: ${value.contentList.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              case Status.completed:
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explore Insights",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: value.contentList.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            var content = value.contentList.data![index];
                            return GestureDetector(
                                onTap: () {
                                  context.push('/content_detail/${content.id}');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ContentCard(content),
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
