# RX Swift notes

---

## 1/ Getting started

### 1.1/ Observer & Observable:

- Observer lắng nghe sự thay đổi của Observable.
- Observable phát ra tín hiệu (completion, giá trị, error) đến các observer thông qua các method.
- Khi observable phát ra 1 tín hiệu completed (onCompleted) hoặc error (onError) thì những lần sau đó observer sẽ không được được tín hiệu giá trị thông qua hàm onNext nữa.

Code example: 

```swift
// DisposeBag là 1 thành phần của thư viện RxSwift, dùng để quản lý bộ nhớ, nó sẽ là nơi lưu trữ các quá trình subscription (observer lắng nghe observable), và xử lý việc giải phóng khi vòng đời của đối tượng kết thúc (deinit)
let disposeBag = DisposeBag()

// Khởi tạo một Observable
let observable = Observable.from(["☘️", "🍀", "🧨", "🔥"])
observable
    // Thực hiện việc đăng ký lắng nghe thay đổi của Observable
    .subscribe(
        onNext: { data in
            // Nơi Observer nhận dữ liệu được phát ra
            print(data)
        },
        onError: { error in
            // Nơi Observer nhận error và Observable được giải phóng
            print(error)
        },
        onCompleted: {
            // Nơi nhận sự kiện Observable hoàn thành và Observable được giải phóng
            print("Completed")
        }
    )
    .disposed(by: disposeBag)

/* Output:
☘️
🍀
🧨
🔥
*/
```



### 1.2/ Subjects:

Là 1 đối tượng có thể là 1 observable hoặc 1 observer.

#### 1.2.1/ PublishSubject:

Là 1 observable có thể phát giá trị ra ngay sau lúc khởi tạo, không cần khai báo giá trị mặc định.

```swift
let subject: PublishSubject<String> = PublishSubject()

// Phát giá trị 1
subject.onNext("one")

// Lắng nghe thay đổi
subject
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)

// Phát giá trị 2
subject.onNext("two")
// Phát giá trị 3
subject.onNext("three")

/* Output:
two
three
*/
```

#### 1.2.2/ BehaviourSubject:

Tương tự như PublishedSubject, nhưng Behaviour nó sẽ luôn có 1 giá trị, nếu có 1 observer đăng ký lắng nghe đến nó, thì nó sẽ lấy giá trị gần nhất được phát ra.

```swift
// Khởi tạo BehaviourSubject với giá trị mặc định là "none"
let subject: BehaviorSubject<String> = BehaviorSubject(value: "default-value")

// Phát ra giá trị, đây sẽ được tính là lần phát ra gần nhất của subject
// Nếu không có dòng này, thì nó sẽ lấy giá trị "default-value"
subject.onNext("one")

subject
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)


subject.onNext("two")
subject.onNext("three")

/* Output
-> one
-> two
-> three
*/
```

#### 1.2.3/ ReplaySubject:

Tương tự như BehaviourSubject ở 1 điểm là nó sẽ nhận được giá trị của lần phát gần đó, nhưng xịn hơn là nó có thể giới hạn được số lượng phần tử muốn nhận, thông qua tham số `bufferSize`, giá trị trước đó sẽ được lưu vào bộ nhớ đệm, nên hãy cẩn thận nếu dùng bufferSize quá lớn mà chưa biết cách quản lý bộ nhớ.

```swift
// 1: Khởi tạo 1 ReplaySubject với số lượng bufferSize là 2.
let subject = ReplaySubject<String>.create(bufferSize: 2)

// 2: Phát ra 3 giá trị.
subject.onNext("one")
subject.onNext("two")
subject.onNext("three")

// 3: Observer bắt đầu lắng nghe thay đổi.
subject
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)

// 4: Tiếp tục phát giá trị.
subject.onNext("four")
subject.onNext("five")

/* Output: Observer sẽ nhận 2 giá trị gần nhất từ khi nó được khởi tạo ở bước 3, 2 giá trị đó  là two và three.

-> two
-> three
-> four
-> five

*/

```

Thử lại code trên với 1 sự kiện onError trước khi thực hiện bước 4.

```swift
subject.onError(MyRxError.common)
// 2 lần này sẽ ko được thực hiện vì quá trình lắng nghe đã dừng
subject.onNext("four")
subject.onNext("five")

/* Output:
-> two
-> three
*/
```







### 2/ RxCocoa

RxCocoa cũng là 1 thư viện như RxSwift, hỗ trợ nhiều cho việc lắng nghe các sự kiện từ các UI element.
