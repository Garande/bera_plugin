import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/app_user.dart';
import '../models/chat.dart';
import '../common/helpers.dart';
import '../widgets/empty_list_message_view.dart';
import 'chat_screen.dart';
import 'cubit/all_chats_cubit.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({Key? key, required this.apiKey, this.userId})
      : super(key: key);
  final String apiKey;
  final dynamic userId;

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllChatsCubit()..initChat(widget.userId, widget.apiKey),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45.0),
                _buildHeader(context),
                const SizedBox(height: 10.0),
                Expanded(
                  child: BlocBuilder<AllChatsCubit, AllChatsState>(
                      builder: (context, state) {
                    return StreamBuilder<List<Chat>>(
                        stream: context.read<AllChatsCubit>().getChatsStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          List<Chat> chats = snapshot.data ?? [];

                          if (chats.isEmpty) {
                            return const Center(
                              child: EmptyListMessageView(
                                iconPath: 'assets/images/icons/tab-2.svg',
                                title: 'No Chat found!',
                                description:
                                    'Looks like there are no chats available',
                                actionButtonMessage: '',
                                hasButton: false,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: chats.length,
                            padding: const EdgeInsets.all(0),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              // Doctor doctor = Doctor.doctors[0];
                              Chat chat = chats[index];

                              AppUser? peer =
                                  Helpers.getChatPeer(state.myId, chat.members);

                              return InkWell(
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        peerId: peer!.id!,
                                        apiKey: widget.apiKey,
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                              peer?.imageUrl ?? '',
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Center(
                                                  child: Text(
                                                    '${peer?.firstName != null ? peer?.firstName![0] : peer?.firstName != null ? peer?.firstName![0] : 'B'}',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                          fontSize: 25.0,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${peer?.firstName} ${peer?.lastName}",
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                          fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 3.0),
                                                Text(
                                                  chat.latestMessage?.type == 0
                                                      ? '${chat.latestMessage?.content}'
                                                      : '[Media]',
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                          fontSize: 14.0),
                                                ),
                                                // const SizedBox(height: 3.0),
                                                // Text(
                                                //   doctor.experience ?? '',
                                                //   textAlign: TextAlign.left,
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodyLarge
                                                //       ?.copyWith(fontSize: 13.0),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    const Divider(height: 1.0),
                                  ],
                                ),
                              );
                            },
                          );
                        });
                  }),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Text(
          'CHATS',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18.0,
              ),
        ),
        const SizedBox(
          height: 30,
          width: 30,
        )
      ],
    );
  }
}
