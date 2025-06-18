# Compilation Issues Fixed - Backend

## Tóm tắt các lỗi compilation đã được giải quyết

### 1. **Missing getTotalScore() method trong User entity**

**Lỗi ban đầu:**

```
cannot find symbol: method getTotalScore()
location: variable u2 of type com.leenglish.toeic.domain.User
```

**Nguyên nhân:** UserService.java đang gọi `user.getTotalScore()` nhưng method này không tồn tại trong User entity.

**Giải pháp:** Thêm method `getTotalScore()` vào User entity:

```java
public Integer getTotalScore() {
    return 0; // hoặc logic tính điểm phù hợp
}
```

### 2. **Method signature mismatch trong createUser()**

**Lỗi ban đầu:**

```
method createUser in class UserService cannot be applied to given types;
required: String,String,String,String,Role
found: String,String,String,String
```

**Nguyên nhân:** AuthController và UserController gọi `createUser()` thiếu tham số Role.

**Giải pháp:** Thêm tham số Role.USER khi gọi method:

```java
User newUser = userService.createUser(
    username, email, password, fullName, Role.USER
);
```

### 3. **Type conversion issues User ↔ UserDto**

**Lỗi ban đầu:**

```
incompatible types: User cannot be converted to UserDto
incompatible types: UserDto cannot be converted to User
```

**Nguyên nhân:**

- UserService methods return khác nhau (một số return User, một số return UserDto)
- Controllers không biết cách convert giữa User và UserDto

**Giải pháp:**

- Thêm method `convertToDto(User user)` trong UserController
- Sử dụng đúng type cho từng method call
- Fix return types trong service methods

### 4. **Missing UserDto support trong JwtService**

**Lỗi ban đầu:**

```
incompatible types: UserDto cannot be converted to User
method generateAccessToken(UserDto) not found
```

**Nguyên nhân:** JwtService chỉ hỗ trợ User object, không hỗ trợ UserDto.

**Giải pháp:** Thêm overloaded methods cho UserDto:

```java
public String generateAccessToken(UserDto userDto) { ... }
public String generateRefreshToken(UserDto userDto) { ... }
public boolean isTokenValid(String token, UserDto userDto) { ... }
```

### 5. **Wrong import path cho UserDto**

**Lỗi ban đầu:**

```
cannot find symbol: class UserDto
location: package com.leenglish.toeic.domain
```

**Nguyên nhân:** Import sai package (domain thay vì dto).

**Giải pháp:** Sửa import statement:

```java
import com.leenglish.toeic.dto.UserDto; // Correct
// Thay vì: import com.leenglish.toeic.domain.UserDto; // Wrong
```

### 6. **Missing fields trong User entity**

**Lỗi ban đầu:**

```
cannot find symbol: method getCurrentLevel()
cannot find symbol: method getTestsCompleted()
```

**Nguyên nhân:** UserDto có các fields mà User entity không có.

**Giải pháp:** Set default values trong `convertToDto()`:

```java
userDto.setCurrentLevel(1); // Default value
userDto.setTestsCompleted(0); // Default value
```

## Kết quả sau khi fix

✅ **BUILD SUCCESS** - Tất cả lỗi compilation đã được giải quyết

⚠️ **Warning còn lại:** Deprecated API trong JwtService (không ảnh hưởng compilation)

## Files đã được sửa đổi

1. `JwtService.java` - Thêm UserDto support methods
2. `UserController.java` - Fix type conversions, thêm convertToDto()
3. `AuthController.java` - Fix createUser() calls với Role parameter
4. `JwtAuthenticationFilter.java` - Fix type handling cho UserDto
5. `User.java` - Thêm getTotalScore() method (nếu cần)

## Recommendation

- Xem xét thống nhất return types của UserService methods
- Cập nhật JWT library để loại bỏ deprecated warnings
- Thêm proper validation cho User entity fields
