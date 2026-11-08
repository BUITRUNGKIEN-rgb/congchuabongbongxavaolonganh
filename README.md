# ♻ AI02 – Trường học xanh | AIX – UNETI12

Website và mã nguồn cho bài toán nhận diện 6 loại rác: `cardboard`, `glass`, `metal`, `paper`, `plastic`, `trash`.

> **ĐỌC TRƯỚC:** Trang GitHub Pages sử dụng mô hình **CLIP pretrained zero-shot** (một demo tham khảo) chạy trên trình duyệt. **Đây không phải checkpoint của đội AIX**, và chưa có Macro-F1 được kiểm chứng trên dữ liệu AI02. Mô hình đội muốn dùng chính thức phải được huấn luyện và triển khai riêng. Không được trình bày kết quả demo CLIP là kết quả mô hình đã nộp.

## A. Cách đưa website lên GitHub — không cần cài Python

1. Giải nén ZIP. Mở thư mục `UNETI12_AIX_AI02_GITHUB_READY`.
2. Vào **https://github.com/new**, tạo repo tên `UNETI12-AIX-AI02`, chọn **Public** và **không** tích tạo README (repo rỗng).
3. Mở repo mới, chọn **uploading an existing file** hoặc **Add file → Upload files**. Kéo **toàn bộ nội dung bên trong thư mục** lên GitHub, bao gồm `index.html`, `assets/`, `.github/`, `backend/`, `training/` và `README.md`.
   - **Quan trọng:** Phải đặt `index.html` ở **gốc repository**, không để trong một thư mục con. Nếu trình duyệt bỏ sót tệp ẩn như `.github/`, có thể dùng `PUSH_LEN_GITHUB.bat` ở mục B để đẩy toàn bộ.
4. Nhấn **Commit changes**.
5. Vào **Settings → Pages** của repo, trong **Build and deployment → Source** chọn **GitHub Actions**.
6. Vào tab **Actions**. Workflow **Deploy AI02 website to GitHub Pages** sẽ chạy sau lần push/commit. Nếu chưa chạy, chọn workflow đó và nhấn **Run workflow**.
7. Đợi workflow có dấu xanh. URL website có dạng:
   `https://TEN_GITHUB.github.io/UNETI12-AIX-AI02/`

Nếu chỉ nhìn thấy README mà không thấy website, hãy kiểm tra bước 5 và xem log Actions. Tên tài khoản và URL trên chỉ là **ví dụ**, chưa phải link đã được triển khai.

### Website dùng như thế nào?

- Mở website trên **Chrome hoặc Edge phiên bản mới**.
- Chọn ảnh JPG/PNG/WEBP (tối đa 8 MB) rồi nhấn **Phân loại bằng AI**.
- **Lần đầu** cần tải thư viện + trọng số mô hình CLIP từ CDN/Hugging Face, dung lượng có thể lớn và chậm trên CPU hoặc mạng yếu.
- Ảnh được xử lý trên thiết bị của người dùng, không gửi tới máy chủ AIX. Tuy nhiên trình duyệt phải kết nối CDN và nơi lưu trọng số để tải mã/mô hình.
- Hiển thị điểm phù hợp tương đối cho 6 mô tả; **không phải xác suất đúng đã hiệu chuẩn**.

## B. Cách đẩy bằng một file BAT (nếu đã cài Git)

1. Tạo **repository Public trống** trên GitHub như bước A.2.
2. Nhấp đúp `PUSH_LEN_GITHUB.bat`.
3. Khi được hỏi, dán URL HTTPS repository, ví dụ `https://github.com/ten-tai-khoan/UNETI12-AIX-AI02.git`.
4. Đăng nhập GitHub khi được yêu cầu. Không dùng mật khẩu GitHub thường làm Personal Access Token.
5. Sau đó bật GitHub Pages tại **Settings → Pages → GitHub Actions**.

Lệnh BAT không tạo repository trên GitHub; nó chỉ đẩy vào repository đã tồn tại. Không chia sẻ token, `.env` hoặc dữ liệu BTC riêng tư.

## C. Cấu trúc thư mục

```text
UNETI12_AIX_AI02_GITHUB_READY/
├── index.html                  # Trang chủ GitHub Pages
├── assets/
│   ├── app.mjs                 # Tải ảnh, hiển thị kết quả
│   ├── inference.mjs           # CLIP pretrained chạy trong trình duyệt
│   ├── categories.mjs          # 6 lớp và gợi ý phân loại
│   ├── style.css               # Giao diện responsive
│   └── favicon.svg
├── .github/workflows/
│   ├── pages.yml               # Tự triển khai GitHub Pages
│   └── quality.yml             # Kiểm tra cú pháp mã
├── backend/                    # Backend Python tùy chọn cho model đội
│   ├── app.py                  # Web Gradio, KHÔNG Streamlit
│   ├── src/                    # Bộ mã dự đoán AI02
│   ├── model/README.md         # Chưa có checkpoint thật
│   └── requirements.txt
├── training/                   # Bộ tối ưu AI02 và baseline BTC
│   ├── src/
│   ├── baseline_BTC/
│   ├── requirements.txt
│   └── README.md
├── PUSH_LEN_GITHUB.bat
├── PUSH_LEN_GITHUB.ps1
└── README.md
```

## D. Dùng mô hình tối ưu **của đội** thay cho CLIP demo

Trang tĩnh GitHub Pages **không thể chạy trực tiếp** Python `.joblib`/`.pth`. Nếu muốn dùng mô hình AIX đã huấn luyện:

1. Huấn luyện từ `training/` bằng dữ liệu AI02 được phép sử dụng, theo `training/README.md`.
2. Chép **nguyên bộ** `AIX_AI02_EXPERIMENT/model/` sang `backend/model/` (bao gồm `manifest.json`, các file `.joblib`, và `.pth` nếu backbone yêu cầu).
3. Chạy thử backend bằng Python 3.11/3.12: `cd backend`, cài `requirements.txt`, rồi `python app.py`.
4. Triển khai thư mục `backend/` lên một dịch vụ **chạy Python**, ví dụ Hugging Face Spaces (Gradio). GitHub giữ mã nguồn, Space phục vụ mô hình qua link công khai.
5. Nếu muốn website GitHub Pages ở trên sử dụng model đội thay vì CLIP, phải tích hợp API của backend hoặc chuyển model sang ONNX/TensorFlow.js và sửa `assets/inference.mjs`. **Chưa có tích hợp này trong bản ZIP**, vì chưa có checkpoint thật.

**Không tải bộ dữ liệu BTC hoặc thông tin riêng tư lên GitHub Public** nếu không được phép. GitHub chặn file lớn hơn 100 MB khi push Git thường; `.pth` lớn nên lưu trên dịch vụ phù hợp hoặc dùng Git LFS có kiểm tra hạn mức.

## E. Kiểm tra trước khi đẩy

- Có `index.html` ở gốc và `.github/workflows/pages.yml`.
- Không có `.venv/`, dữ liệu BTC riêng tư, file `.env`, hoặc mật khẩu.
- Mở `index.html` bằng trình duyệt để xem giao diện. Để chạy AI, dùng URL GitHub Pages với Internet; khi mở bằng `file://`, một số trình duyệt có thể chặn module JS.
- Nếu trang trắng: F12 → Console, kiểm tra `assets/app.mjs` có tải được không.
- Nếu không tải được AI: kiểm tra kết nối CDN/Hugging Face, trình duyệt, bộ nhớ và chính sách mạng. Trang vẫn hiển thị giao diện, nhưng không được giả kết quả phân loại.

## F. Trạng thái và phạm vi

- Website và source đã đóng gói; không có checkpoint mô hình của đội hoặc dữ liệu thật.
- Chưa chạy kiểm chứng Macro-F1 trên TrashNet của đội.
- Bản này được tạo sau hạn nộp ghi trong đề; **không đồng nghĩa với sản phẩm đã nộp đúng hạn**.
- Mục tiêu: website tham khảo công khai + bộ mã AI02 để học tập, demo và phát triển tiếp.
