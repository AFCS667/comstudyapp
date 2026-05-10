import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MeetupScreen extends StatefulWidget {
  const MeetupScreen({super.key});

  @override
  State<MeetupScreen> createState() => _MeetupScreenState();
}

class _MeetupScreenState extends State<MeetupScreen> {
  final Color background = AppColors.background;
  final Color onBackground = AppColors.onBackground;
  final Color primaryContainer = AppColors.primaryContainer;
  final Color primary = AppColors.primary;
  final Color highlight = AppColors.highlight;
  final Color error = AppColors.error;
  final Color onSurface = AppColors.onSurface;
  final Color tertiaryFixed = AppColors.tertiaryFixed;
  final Color tertiary = AppColors.tertiary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderSection(),
                _buildMapSection(),
                _buildNearbyMeetups(),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav()),
        ],
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(51), // 0.2 * 255
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAYizP9Lxk-WQRq151xlG0yYsgfjfhkTcSsEhjVVFqoimdskMU85VO0huJK3X-2ETw3TXuiu-R0E8HJnplDBnuSH0yXsfxy9s3rIJUViO6GHvbPMBYTv89zgwRBLVTl1CBPyvvjCo-SltaqzUeegHwnkl55wDmNez9gUIDFEel46eUL50ODZ-vpWZ8WJcUO7a2HfUcPYhQHV7IzkNoetFgsAYVCWfpfbRlVT0xV1Y8VTI0jBVODUI5qzmmRsZq2c7_6e__IIuIVZGKE',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Bryan Carlos',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.search, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 48),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Meetups',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Connect with fellow curators in your area',
            style: TextStyle(
              color: Color(0xFFC9DBFF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 192,
          decoration: BoxDecoration(
            color: const Color(0xFFE3E2E6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Opacity(
                  opacity: 0.8,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC8uZ7mcFOlKBABmXlvkYz9jsmOGn88fw2looeHutPjFJL9hlbp5Zn3N5vJi5Ko61XMSi5YbegrREzgK-YnJbQaBRz2YXTfRG-9l6KjehZbn1FMvD6UApsOTvTJs9fmlWqGXDhvKaoZdid5N3ocFP9Xeh0TgWHD3huRPZwlnn-UvE5faDo2Qyy2krCqkXCBK88uF_jYSV6eRP28ilukl2YgytvAiCEhdUxlMd6LvXwCeLZZyA5YZHi-ctNsFhnCU7CdnRYb9y53lI78',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(top: 48, left: 80, child: _buildLocationPin(primary)),
              Positioned(
                top: 96,
                right: 64,
                child: _buildLocationPin(tertiary),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230), // 0.9 * 255
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.my_location, color: primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPin(Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(Icons.location_on, color: Colors.white, size: 16),
    );
  }

  Widget _buildNearbyMeetups() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Meetups',
                style: TextStyle(
                  color: onBackground,
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View Map',
                style: TextStyle(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildMeetupCard(
            title: 'Digital Curation Masterclass',
            dateLocation: 'Today, 14:00 • Central Gallery',
            bgColor: highlight,
            titleColor: onSurface,
            tagText: 'Live',
            tagColor: error,
            tagTextColor: Colors.white,
            avatars: [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCOsDjQ7FbWs9tz0gFArtz0IQWd65LsqhUNHgFgZPEoaHOyzitlVCIs90S929JstaRZqB5drLgiucfbRz1zeSwIOIJd2AoAUX1hXfYqgPRJIo5UyCM48Htwj3_TygJroaFB_spnxwDI3Wz0YIKwM8TJC3Sag7l-JMiKC6B9ao0ZrlmgMGo2JMXnzbS9BhzBkc2xGAZoJgEB1FF5k7kbr_4cLIBoAwi4oG3XcxUFbPuhjzP3dcsCMelJP-pfD95G91GxQkvU6ig5mngT',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuARa-a9Tval9yLjHuzjgrX4sRCAtu-LXADQ7dLKwLWi47Tb2XNkLqrn2yYtfrAGeNv6I-GP3d6l1oBgSwKyLFgpD9em9s-GVtpJbJ48uSxvDrlTN47ik-o2TtNS_pcvhDjdzsOJCmIfpxDFAm1vgCiznMStQhPEdx6wOBnWz4HGA_dhynqs1fL3S1cZygl8an8Gq7CNZmW3V4YAeCu6Yte6JjiMCp09NX0udB9ek-B_EZ8bJqgEPKjQW3IV2Kc47OOTJLPjVl8WODDX',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAsfo_mMIU9n3AhM5gxoaOfBH-vEBTL0Sf6CjANVqHdovte6Y5yI_6iijjf5w3K9_LoD0O3-VZZ94NT-4ynbzrpiyOzp7a9WCCx3kI9FjO8-au97AksV2sjKih9sbmGv2zOX5vKdHzF2OjuxG_H-VZyUAVvh9mAZha1RwRpio1-OANXpqnUORSt6m0UegSdQd8FV0XWscjyqSLzRMXtksVck0lh1LlB2eOKQ5lDXN9IUJpIaV071iJ83TPY50SH1EHwFsNRmZdJzBFQ',
            ],
            extraCount: '+12',
            buttonText: 'Join',
            buttonColor: onSurface,
            buttonTextColor: Colors.white,
          ),
          const SizedBox(height: 24),
          _buildMeetupCard(
            title: 'Typography & Coffee',
            dateLocation: 'Sat, 21 Oct • Brew & Bind',
            bgColor: highlight,
            titleColor: onSurface,
            tagText: 'Offline',
            tagColor: onSurface.withAlpha(26), // 0.1 * 255
            tagTextColor: onSurface.withAlpha(153), // 0.6 * 255
            avatars: [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBvWx4Jqc7N_ECLBf8xxUiGu8S10crECLTc2on_D2bgykhHHR7JN_ImY2jPF_y5MpY_2ARrFfM0pTkLcZUQSxCT0UAW7Zf7cAfjs4ECQgtHTY63BHmRuUbN-XWc6o_o-0kqXiSb7lmJATRNt-9KBO7nzfAUHF2nn-bsIcPqO4RKY6_Dgjorkd-xV6W8QHu2SjX8sK3ZAd-s0vJ1AOeNR4fAgKMHDblnKrykKYIMZ1J3KozVk_1L9cIqbZatuKHqhHkSjaR4OfNyG-AQ',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCI713G6nnV-Kzs3ba3kJZDddM3ZLNPp374EpzNP02vTPx8QQVbVzsq1Z0teznIlAcmHwJZ20lD3nRqEB0JCt75w7puLQRBdUOw7HcEIGcF_GZbG4jQNBg9Z-zRUlesX6thRIaOJj0YyU8iKIPMKHTMlZwHFJJGkjabeD6kKJZ6Q67lJGQenOK6B98LUdkEqaBLgl5-gsrj1PdMwIDVjy9NEHggGX4Oh-hyytn5Kb3GvL7aPtgllUQ24Oja9x4jkT4p0cUQQWk6KD1L',
            ],
            extraCount: '+8',
            buttonText: 'Details',
            buttonColor: onSurface.withAlpha(26), // 0.1 * 255
            buttonTextColor: onSurface,
          ),
          const SizedBox(height: 24),
          _buildMeetupCard(
            title: 'Sustainability in Art',
            dateLocation: 'Sun, 22 Oct • The Greenhouse',
            bgColor: tertiaryFixed,
            titleColor: const Color(0xFF082100),
            tagText: 'New',
            tagColor: tertiary,
            tagTextColor: Colors.white,
            avatars: [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAJkeQ_upZHMM8pRSFVcNfDs34i3jAJsfvbLeAogbBUP8SKuxbWyQOEqh1mJi2rBWk_ItS0MXNItSpJFuOhDB9ppUPx7qkZfb_Okc8Z_kgJPMIdF9ki9GQaKY0QexR3qGRMrj_PBnImk2pEmITnbGf6lzmpQxn2IlUkLMT9DemSirus_S1leGl5sSDt-MvMEI71Dp1LBR2MP6zOtPp5NhDRpKX6prbF8G0F6wZdRgQsdp9-VMM6ls82uz_3EKBDhLLenywcATfizenf',
            ],
            extraCount: '+4',
            buttonText: 'Interested',
            buttonColor: tertiary,
            buttonTextColor: Colors.white,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildMeetupCard({
    required String title,
    required String dateLocation,
    required Color bgColor,
    required Color titleColor,
    required String tagText,
    required Color tagColor,
    required Color tagTextColor,
    required List<String> avatars,
    required String extraCount,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 64),
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: titleColor.withAlpha(179), // 0.7 * 255
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateLocation,
                    style: TextStyle(
                      color: titleColor.withAlpha(179), // 0.7 * 255
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < avatars.length; i++)
                        Transform.translate(
                          offset: Offset(i * -12.0, 0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: bgColor,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(avatars[i]),
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(avatars.length * -12.0, 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: titleColor.withAlpha(26), // 0.1 * 255
                            border: Border.all(color: bgColor, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            extraCount,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tagText.toUpperCase(),
                style: TextStyle(
                  color: tagTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
