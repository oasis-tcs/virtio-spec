le32 {
	union {
		vq_index: 16; /* Used if VIRTIO_F_NOTIF_CONFIG_DATA not negotiated */
		vq_notif_config_data: 16; /* Used if VIRTIO_F_NOTIF_CONFIG_DATA negotiated */
	};
	next_off : 15;
	next_wrap : 1;
};
