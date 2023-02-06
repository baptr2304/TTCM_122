create database QuanLyThietBiYTeTaiBenhVienDaNang
go
use QuanLyThietBiYTeTaiBenhVienDaNang
go
create table ChucVu
(
	maChucVu varchar(10) not null CONSTRAINT PK_ChucVu_maChucVu primary key,
	tenChucVu nvarchar(100)
)
go
create table NhaCungCap
(
	maNCC varchar(10) not null CONSTRAINT PK_NhaCungCap_maNCC primary key,
	tenNCC nvarchar(100)
)
go
create table Khoa
(
	maKhoa varchar(10) not null CONSTRAINT PK_Khoa_maKhoa primary key,
	tenKhoa nvarchar(100)
)
go
create table DanhMuc
(
	maDanhMuc varchar(10) not null CONSTRAINT PK_DanhMuc_maDanhMuc primary key,
	tenDanhMuc nvarchar(100)
)

go
create table CanBo
(
	maCB varchar(10)  not null,
	tenCB nvarchar(100),
	taiKhoan varchar(10) CONSTRAINT UQ_CanBo_taiKhoan unique,
	matKhau varchar(10),
	maKhoa varchar(10) CONSTRAINT FK_CanBo_maKhoa foreign key references Khoa(maKhoa)
		on update cascade
		on delete cascade,
	maChucVu varchar(10) CONSTRAINT FK_CanBo_maChucVu foreign key  references ChucVu(maChucVu)
		on update cascade
		on delete cascade
	CONSTRAINT PK_CanBo_maCB primary key(maCB)
)
go
create table PhieuNhap
(
	maDeXuat varchar(10) not null CONSTRAINT PK_PhieuNhap_maDeXuat primary key,
	noiDungDeXuat nvarchar(200),
	ngayDeXuat date,
	maCBDeXuat varchar(10) CONSTRAINT FK_PhieuNhap_maCBDeXuat foreign key references CanBo(maCB),
	ngayDuyet date,
	ngayNhap date,
	maCBNhap varchar(10) CONSTRAINT FK_PhieuNhap_maCBNhap foreign key references CanBo(maCB),
	maNCC varchar(10) CONSTRAINT FK_PhieuNhap_maNCC foreign key references NhaCungCap(maNCC)
		on update cascade
		on delete cascade
)
go
create table PhieuXuat
(
	maXuat varchar(10) not null CONSTRAINT PK_PhieuXuat_maXuat primary key,
	ngayXuat date,
	maCBXuat varchar(10) CONSTRAINT FK_PhieuXuat_maCBXuat foreign key  references CanBo(maCB),
	ngayNhan date,
	maCBNhan varchar(10) CONSTRAINT FK_PhieuXuat_maCBNhan foreign key references CanBo(maCB),
	maDeXuat varchar(10) CONSTRAINT FK_PhieuXuat_maDeXuat foreign key references PhieuNhap(maDeXuat)
		on update cascade
		on delete cascade
)
go
create table ThietBi
(
	maThietBi varchar(10) not null CONSTRAINT PK_ThietBi_maThietBi  primary key,
	tenThietBi nvarchar(100),
	soLuongHienCon int,
	soLuongDaDung int,
	moTa nvarchar(500),
	maDanhMuc varchar(10) CONSTRAINT FK_ThietBi_maDanhMuc foreign key references DanhMuc(maDanhMuc)
		on update cascade
		on delete cascade
)
go
create table ChiTietXuat
(
	maPhieuXuat varchar(10) CONSTRAINT FK_ChiTietXuat_maPhieuXuat not null foreign key references PhieuXuat(maXuat)
		on update cascade
		on delete cascade,
	maThietBi varchar(10) CONSTRAINT FK_ChiTietXuat_maThietBi not null foreign key references ThietBi(maThietBi)
		on update cascade
		on delete cascade,
	soLuongXuat int,
	soLuongNhan int,
	tinhTrangTB nvarchar(100)
	CONSTRAINT PK_ChiTietXuat_maPhieuXuatmaThietBi primary key (maPhieuXuat, maThietBi)
)
go
create table ChiTietDuyetDeXuat
(
	maDeXuat varchar(10) not null CONSTRAINT FK_ChiTietDuyetDeXuat_maDeXuat foreign key references PhieuNhap(maDeXuat)
		on update cascade
		on delete cascade,
	maThietBi varchar(10) not null  CONSTRAINT FK_ChiTietDuyetDeXuat_maThietBi foreign key references ThietBi(maThietBi)
		on update cascade
		on delete cascade,
	soLuongDeXuat int,
	soLuongDuocDuyet int,
	soLuongNhapVe int
	CONSTRAINT PK_ChiTietDuyetDeXuat_maDeXuatmaThietBi primary key (maDeXuat, maThietBi)
)
-- CONSTRAINTs
-- Bảng Phiếu Nhập
-- Ràng buộc ngày
go
alter table PhieuNhap
	add constraint CK_PhieuNhap_date check(ngayDeXuat <= getdate() and ngayDuyet <= getdate() and ngayNhap <= getdate() 
									and	   ngayDeXuat <= ngayDuyet and ngayDuyet <= ngayNhap)
-- Bảng Phiếu Xuất
-- Ràng buộc ngày
go
alter table PhieuXuat
	add constraint CK_PhieuXuat_date check(ngayXuat <= getdate() and ngayNhan <= getdate()
									and	   ngayXuat = ngayNhan),
-- Ràng buộc giá trị mặc định 
		constraint DF_PhieuXuat_maCBXuat default 'CB08' for maCBXuat with values

-- Bảng Chi Tiết Duyệt Đề Xuất
-- Ràng buộc Số lượng
go
alter table ChiTietDuyetDeXuat
	add constraint CK_ChiTietDuyetDeXuat_SoLuong check (soLuongDeXuat >= 0 and soLuongDuocDuyet >=0 and soLuongNhapVe >= 0 and
														soLuongNhapVe <= soLuongDuocDuyet and soLuongDuocDuyet <= soLuongDeXuat)
-- Bảng Chi Tiết Xuất
-- Ràng buộc Số lượng
go
alter table ChiTietXuat
	add constraint CK_ChiTietXuat_SoLuong check	(soLuongXuat >= 0 and soLuongNhan >=0 and
												 soLuongXuat <= soLuongNhan),
-- Ràng buộc giá trị mặc định 
		constraint DF_ChiTietXuat_TinhTrangTB default N'Bình Thường' for tinhTrangTB with values

-- Bảng Thiết Bị
-- Ràng buộc Số lượng
go
alter table ThietBi
	add constraint CK_ThietBi_SoLuong check (soLuongHienCon >= 0 and soLuongDaDung >=0)

-- Chèn dữ liệu vào các bảng
go
insert into ChucVu(maChucVu, tenChucVu)
values	('CV01', N'Nhân viên khoa'),
		('CV02', N'Nhân viên quản lí thiết bị'),
		('CV03', N'Trưởng phòng quản lí thiết bị'),
		('CV04', N'Nhân viên kho'),
		('CV05', N'Giám Đốc')
go
insert into Khoa(maKhoa, tenKhoa)
values	('K01',N'Nội hô hấp'),
		('K02',N'Răng hàm mặt'),
		('K03',N'Tai mũi họng'),
		('K04',N'Nội tim mạch'),
		('K05',N'Nội Tiêu hóa – Gan mật'),
		('K06',N'Nội thận – Nội tiết'),
		('K07',N'Nội thần kinh – cơ xương khớp – truyền máu'),
		('K08',N'Gây Mê Hồi Sức'),
		('K09',N'Ung bướu'),
		('K10',N'Phụ sản')
go
insert into NhaCungCap(maNCC, tenNCC)
values	('NCC01',N'Công ty Thiết bị y tế Phương Mai'),
		('NCC02',N'Công ty Cổ phần Vật tư y tế Hà Nội'),
		('NCC03',N'Công ty Thiết bị y tế Việt Nam – CTCP Vinamed'),
		('NCC04',N'Công ty TNHH Thiết bị Y tế Huê Lợi'),
		('NCC05',N'Cổ phần Thiết bị y tế Metech.'),
		('NCC06',N'Hanoi IEC.'),
		('NCC07',N'TNHH thiết bị y tế Hoàng Lộc M.E.'),
		('NCC08',N'Hapharco.'),
		('NCC09',N'Công ty TNHH xuất nhập khẩu y tế Thăng Long'),
		('NCC10',N'Công ty TNHH Thiết bị khoa học và y tế MPT')
go
insert into DanhMuc(maDanhMuc,tenDanhMuc)
values	('DM01', N'TTBYT Loại A'),
		('DM02', N'TTBYT Loại B'),
		('DM03', N'TTBYT Loại C'),
		('DM04', N'TTBYT Loại D')
go
insert into ThietBi(maThietBi, tenThietBi, soLuongHienCon, soLuongDaDung, moTa, maDanhMuc)
values	('TB1', N'	Môi trường nuôi cấy vi khuẩn',1000,200,N'Môi trường nuôi cấy vi khuẩn, là môi trường sinh trưởng được sử dụng để nuôi cấy vi khuẩn. Nó chứa đầy đủ các chất dinh dưỡng cần thiết cho sự phát triển của vi khuẩn, nấm mốc; chúng hoàn toàn có sống bên ngoài chủ thể với môi trường này.','DM01'),
		('TB02', N'Mặt nạ thở oxy có túi',40,1000,N'Kỹ thuật làm tăng thêm nồng độ oxy khí thở vào (FiO2) bằng mask có túi dự trữ oxy nhằm cung cấp đủ oxy cho nhu cầu chuyển hóa của cơ thể. Phương pháp này có thể cung cấp FiO2 tới 65-100% tùy vào loại mask có túi dự trữ kèm van một chiều hay không.','DM02'),
		('TB03', N'Bộ xét nghiệm IVD ACTH',1000,200,N'Giúp đánh giá các bệnh liên quan đến tuyến yên và vùng thượng thận','DM03'),
		('TB04', N'Dây dẫn chẩn đoán',30,500,N'Các ống thông chẩn đoán được thiết kế để sử dụng đưa vào hệ thống mạch máu chất có tính cản quang trong chẩn đoán tại một vị trí xác định.','DM04'),
		('TB05', N'Kim luồn tĩnh mạch có cánh',1000,200,N'Với tính năng vượt trội của ống thông lưu đến 96h trong tĩnh mạch đã được chứng minh sau khi theo dõi lâm sàng, Vinacath là sản phẩm được các nhân viên y tế tin dùng, mang lại sự an toàn, thoải mái và tiện lợi cho bệnh nhân.','DM02'),
		('TB06', N'Giường Y tế',20,200,N'giúp nâng hạ lưng, chân, nghiêng trái phải, có bô vệ sinh. Giường bệnh nhân y tế đa năng, hỗ trợ người bệnh tối đa, bảo hành chính hãng, giảm giá 32% Cam kết hàng chính hãng. Được bác sỹ khuyên dùng.','DM01'),
		('TB07', N'Họ khay đựng bảo vệ dụng cụ cho tiệt khuẩn',1000,200,N'Nắp hộp gồm 02 nắp gắn liền nhau: nắp trên không đục lỗ, để bảo vệ cho nắp dưới; nắp dưới sử dụng bộ lọc.','DM01'),
		('TB08', N'	Máy Laser CO2 phẫu thuật',49,200,N'Máy Laser CO2 phẫu thuật được ứng dụng rộng rãi trong các chuyên khoa rất hiệu quả như: ngoại khoa, da liễu, phụ khoa, trĩ, khoa lý liệu, ...','DM03'),
		('TB09', N'Bàn khám sản',10,200,N'Dùng để khám sản, phụ khoa, sanh, siêu âm. So với các sản phẩm trên thì trường thì đây là một loại giường chất lượng cao','DM01'),
		('TB10', N'Bộ cấy trong Điện cực ốc tai - Neuro Zti',1000,300,N'Neuro Zti có thể sử dụng hai dải điện cực khác nhau. Chúng được thiết kế để thoải mái lắp vào mà không làm hỏng cấu trúc ốc tai. Sau khi được lắp vào, chúng cho phép truyền toàn bộ phổ âm thanh bằng cách sử dụng các chiến lược xử lý tín hiệu mới nhất.','DM04')
go
insert into CanBo(maCB, tenCB, taiKhoan, matKhau, maKhoa, maChucVu)
values	('CB01', N'Trần Lê Minh Huy', 'MinhHuy', '123456', 'K01', 'CV01'),
		('CB02', N'Võ Văn Thành', 'VanThanh', '123456', 'K02', 'CV01'),
		('CB03', N'Trương Bảo Phúc', 'BaoPhuc', '123456', 'K03', 'CV01'),
		('CB04', N'Võ Minh Lợi', 'MinhLoi', '123456', 'K04', 'CV01'),
		('CB05', N'Nguyễn Văn A', 'VanA', '123456', 'K05', 'CV01'),
		('CB06', N'Nguyễn Văn B', 'VanB', '123456', 'K06', 'CV01'),
		('CB07', N'Nguyễn Văn C', 'VanC', '123456', 'K07', 'CV03'),
		('CB08', N'Nguyễn Văn D', 'VanD', '123456', 'K07', 'CV04'),
		('CB09', N'Nguyễn Văn E', 'VanE', '123456', 'K07', 'CV01'),
		('CB10', N'Nguyễn Văn F', 'VanF', '123456', 'K09', 'CV02')
go
set dateformat dmy
insert into PhieuNhap(maDeXuat, noiDungDeXuat, ngayDeXuat, maCBDeXuat, ngayDuyet, ngayNhap, maCBNhap, maNCC)
values	('DX01', N'Nhập thiết bị y tế về kho', '5-1-2023', 'CB07', '5-1-2023', null, null, null),
		('DX02', N'Nhập thiết bị y tế về khoa Nội hô hấp', '5-1-2023', 'CB01', '5-1-2023', null, null, null),
		('DX03', N'Nhập thiết bị y tế về kho', '5-2-2023', 'CB07', '5-2-2023', null, null, null),
		('DX04', N'Nhập thiết bị y tế về khoa Răng hàm mặt', '5-2-2023', 'CB02', '5-2-2023', null, null, null),
		('DX05', N'Nhập thiết bị y tế về khoa Nội Tiêu hóa – Gan mật', '5-2-2023', 'CB03', '5-2-2023', null, null, null),
		('DX06', N'Nhập thiết bị y tế về khoa Nội thận – Nội tiết', '5-2-2023', 'CB04', '5-2-2023', null, null, null),
		('DX07', N'Nhập thiết bị y tế về khoa Nội thần kinh – cơ xương khớp – truyền máu', '5-2-2023', 'CB05', '5-2-2023', null, null, null),
		('DX08', N'Nhập thiết bị y tế về khoa Nội thần kinh – cơ xương khớp – truyền máu', '5-2-2023', 'CB06', '5-2-2023', null, null, null),
		('DX09', N'Nhập thiết bị y tế về khoa Nội thần kinh – cơ xương khớp – truyền máu', '5-2-2023', 'CB09', '5-2-2023', null, null, null),
		('DX10', N'Nhập thiết bị y tế về khoa Nội hô hấp', '5-2-2023', 'CB01', '5-2-2023', null, null, null),
		('DX11', N'Nhập thiết bị y tế về khoa Ung bướu', '5-2-2023', 'CB10', '5-2-2023', null, null, null),
		('DX12', N'Nhập thiết bị y tế về khoa Phụ sản', '5-2-2023', 'CB04', '5-2-2023', null, null, null)
go
insert into ChiTietDuyetDeXuat(maDeXuat, maThietBi, soLuongDeXuat, soLuongDuocDuyet, soLuongNhapVe)
values	('DX01','TB02', 200, null, null),
		('DX01','TB04', 500, null, null),
		('DX02','TB02', 100, null, null),
		('DX03','TB08', 100, null, null),
		('DX04','TB06', 50, null, null),
		('DX05','TB02', 100, null, null),
		('DX06','TB08', 50, null, null),
		('DX07','TB08', 50, null, null),
		('DX08','TB08', 50, null, null),
		('DX09','TB05', 100, null, null),
		('DX10','TB02', 100, null, null),
		('DX11','TB07', 200, null, null),
		('DX12','TB07', 200, null, null)
go
insert into PhieuXuat(maXuat, ngayXuat, ngayNhan, maCBNhan, maDeXuat)
values	('X01', null, null, null, 'DX02'),
		('X02', null, null, null, 'DX04'),
		('X03', null, null, null, 'DX05'),
		('X04', null, null, null, 'DX06'),
		('X05', null, null, null, 'DX07'),
		('X06', null, null, null, 'DX08'),
		('X07', null, null, null, 'DX09'),
		('X08', null, null, null, 'DX10'),
		('X09', null, null, null, 'DX11'),
		('X10', null, null, null, 'DX12')
go
insert into ChiTietXuat(maPhieuXuat, maThietBi, soLuongXuat, soLuongNhan)
values	('X01','TB02',100 , null),
		('X02','TB06',50 , null),
		('X03','TB02',100 , null),
		('X04','TB08',50 , null),
		('X05','TB08',50 , null),
		('X06','TB08',50 , null),
		('X07','TB05',100 , null),
		('X08','TB02',100 , null),
		('X09','TB07',200 , null),
		('X10','TB07',200 , null)
go
select CTDDX.maThietBi, tenThietBi, sum(soLuongDeXuat) as N'Số lượng'
from ThietBi as TB
right join ChiTietDuyetDeXuat as CTDDX
on TB.maThietBi = CTDDX.maThietBi
group by CTDDX.maThietBi, tenThietBi
order by CTDDX.maThietBi