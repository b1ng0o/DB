DROP TABLE IF EXISTS `music_playlists`;
CREATE TABLE `music_playlists` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `musics`;
CREATE TABLE `musics` (
	id SERIAL PRIMARY KEY,
	`playlist_id` BIGINT unsigned NOT NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (playlist_id) REFERENCES music_playlists(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `video_albums`;
CREATE TABLE `video_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
	id SERIAL PRIMARY KEY,
	`videolist_id` BIGINT unsigned NOT NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (videolist_id) REFERENCES video_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);


