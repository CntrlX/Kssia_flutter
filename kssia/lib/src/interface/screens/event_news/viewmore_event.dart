import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/services/api_routes/events_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:kssia/src/interface/common/custom_button.dart';

class ViewMoreEventPage extends ConsumerStatefulWidget {
  final Event event;
  const ViewMoreEventPage({super.key, required this.event});

  @override
  ConsumerState<ViewMoreEventPage> createState() => _ViewMoreEventPageState();
}

class _ViewMoreEventPageState extends ConsumerState<ViewMoreEventPage> {
  bool registered = false;
  @override
  void initState() {
    super.initState();
    registered = widget.event.rsvp?.contains(id) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm a').format(widget.event.startTime!);
    String date = DateFormat('yyyy-MM-dd').format(widget.event.startDate!);
    log('rsvp : ${widget.event.rsvp}');
    log('my id : ${id}');
    bool registered = widget.event.rsvp?.contains(id) ?? false;
    log('event registered?:$registered');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: Image.network(
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                              fit: BoxFit.fill,
                              'https://placehold.co/600x400/png');
                        },
                        widget.event.image!, // Replace with your image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFE4483E), // Red background color
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: widget.event.status != null &&
                                widget.event.status != ''
                            ? Row(
                                children: [
                                  Text(
                                    widget.event.status!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 8,
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Event Title
                Text(
                  widget.event.name!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Date and Time
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color(0xFFE30613)),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFFE30613)),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color.fromARGB(255, 192, 188, 188)),
                const Text('Organiser'),
                Text(
                  widget.event.organiserName ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.event.description ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                // Speakers Section
                const Text(
                  'Speakers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.event.speakers!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildSpeakerCard(
                          widget.event.speakers?[index].speakerImage,
                          widget.event.speakers?[index].speakerName ?? '',
                          widget.event.speakers?[index].speakerDesignation ??
                              ''),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Venue Section
                // const Text(
                //   'Venue',
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 8),
                // if (widget.event.venue != null)
                //   Text(
                //     widget.event.venue ?? '',
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                const SizedBox(height: 8),
                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       color: Colors.grey[300],
                //       borderRadius: BorderRadius.circular(5)),
                //   height: 200,
                //   child: Image.asset(
                //     'assets/eventlocation.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                const SizedBox(
                    height: 50), // Add spacing to avoid overlap with the button
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: customButton(
                  buttonColor:
                      registered ? Colors.green : const Color(0xFF004797),
                  label: widget.event.status == 'cancelled'
                      ? 'CANCELLED'
                      : registered
                          ? 'REGISTERED'
                          : 'REGISTER EVENT',
                  onPressed: () async {
                    if (!registered && widget.event.status != 'cancelled') {
                      ApiRoutes userApi = ApiRoutes();
                      await userApi.markEventAsRSVP(widget.event.id!, context);

                      setState(() {
                        widget.event.rsvp?.add(id); // Add the user to RSVP
                        registered = widget.event.rsvp?.contains(id) ?? false;
                      });

                      ref.invalidate(
                          fetchEventsProvider); // Update your global state if needed
                    }
                  },
                  fontSize: 16,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerCard(String? imagePath, String name, String role) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: (imagePath != null && imagePath.isNotEmpty)
              ? NetworkImage(imagePath)
              : null, // Use image if available
          child: (imagePath == null || imagePath.isEmpty)
              ? const Icon(Icons.person, size: 40)
              : null, // Show icon if no image is provided
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          role,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
