package ru.yandex.practicum.filmorate.storage;

import ru.yandex.practicum.filmorate.model.User;

import java.util.Collection;

public interface UserStorage {
    Collection<User> getAll();
    User add(User user);
    User update(User user);
    int size();
    User getUser(Integer id);
}
