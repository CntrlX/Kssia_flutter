const message = {
    notification: {
        title,
        body,
    },
    android: {
        notification: {
            ...(media && { imageUrl: media }),
            ...(tag && { tag }),
            priority: 'high',
            channelId: 'your_channel_id',
        },
    },
}; 