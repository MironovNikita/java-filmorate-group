package ru.yandex.practicum.filmorate.storage.dao;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;
import ru.yandex.practicum.filmorate.model.Review;
import ru.yandex.practicum.filmorate.storage.ReviewLikeStorage;

@Slf4j
@Repository
public class ReviewLikeDbStorage implements ReviewLikeStorage {
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public ReviewLikeDbStorage(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void addLike(int reviewId, int userId) {
        String sqlQueryLike = "INSERT INTO reviews_likes(review_id, user_id) " +
                "values (?, ?) ";
        jdbcTemplate.update(sqlQueryLike,
                reviewId,
                userId);
    }

    @Override
    public Review deleteLike(int reviewId, int userId) {
        return null;
    }

    @Override
    public Review addDisLike(int reviewId, int userId) {
        // писать sql запрос
        return null;
    }

    @Override
    public Review deleteDisLike(int reviewId, int userId) {
        return null;
    }

    @Override
    public Integer getUsefulness(int id) {
        String sqlQueryForLikes = "SELECT COUNT(review_id) AS cntLikes FROM reviews_likes, WHERE is_like = true " +
                "AND review_id = ? ";
        String sqlQueryForDisLikes = "SELECT COUNT(review_id) AS cntDisLikes FROM reviews_likes, " +
                "WHERE is_like = false " +
                "AND review_id = ? ";

        SqlRowSet reviewLikesRows = jdbcTemplate.queryForRowSet(sqlQueryForLikes, id);
        SqlRowSet reviewDisLikesRows = jdbcTemplate.queryForRowSet(sqlQueryForLikes, id);

        int likesCount = 0;
        int disLikesCount = 0;
        if (reviewLikesRows.next()) {
            likesCount = (reviewLikesRows.getInt("cnt"));
            log.info("Обзор id: {} считают полезным {} пользователей", id, likesCount);
        }
        if (reviewDisLikesRows.next()) {
            disLikesCount = (reviewDisLikesRows.getInt("cntDisLikes"));
            log.info("Обзор id: {} считают бесполезным {} пользователей", id, disLikesCount);
        }
        if (likesCount - disLikesCount == 0) {
            log.info("Обзор id: {} не получил оценку полезности со стороны пользователей", id);
        }
        return likesCount - disLikesCount;
    }
}
