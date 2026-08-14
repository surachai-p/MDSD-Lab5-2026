# Notes — campus_marketplace_riverpod_trial

เหตุผลการเลือกใช้เครื่องมือ State Management ในโปรเจกต์ทดลอง Riverpod นี้ อ้างอิงหลักการ Ephemeral State vs App State จากบทเรียน

## 1. รายการโปรด (favoritesProvider / FavoritesNotifier)

**ชนิด State**: App State

**เหตุผล**: รายการที่บันทึกไว้ต้องแสดงผลตรงกันในหลายจุดที่ไม่ได้อยู่ใน Widget เดียวกัน — ทั้งตัวเลข ❤️ ที่ AppBar ของ `HomePage`, ไอคอนหัวใจ (`isFav`) ของแต่ละ `ListTile` ในหน้ารายการ, และรายการทั้งหมดในหน้า `FavoritesPage` ที่ถูก push แยก Route ออกไป ถ้าใช้ `setState` เก็บไว้ที่ Widget เดียวจะเกิด Prop Drilling หรือข้อมูลไม่ sync กันข้าม Route เหมือนปัญหาที่พิสูจน์ไว้ในส่วนที่ 1 ของใบงาน จึงต้องยกระดับเป็น App State ด้วย `StateNotifierProvider`

**ทำไมใช้ `state = [...state, item]` แทนการ mutate list เดิม**: Riverpod ยึดหลัก immutable state — การสร้างลิสต์ใหม่ทั้งก้อนทำให้ Riverpod ตรวจจับการเปลี่ยนแปลงและแจ้งผู้ฟัง (`ref.watch`) ได้แน่นอน ต่างจาก Provider/ChangeNotifier ที่ mutate list ภายในแล้วค่อยเรียก `notifyListeners()` เอง

## 2. `toggle(item)` แทนที่จะมีแค่ `add`

**เหตุผลการออกแบบ**: ในโค้ดต้นแบบ (ส่วนที่ 2) ปุ่มจะ disable หลังบันทึกแล้วเพื่อกันกดซ้ำ แต่ในโปรเจกต์ทดลองนี้เปลี่ยนมาใช้ไอคอนหัวใจ toggle (`favorite` / `favorite_border`) แทน เพื่อให้ผู้ใช้กดซ้ำเพื่อยกเลิกบันทึกได้จากหน้ารายการโดยตรง ไม่ต้องไปหน้า Favorites ก่อน — เมธอด `toggle()` เรียก `isFavorite()` เช็คสถานะปัจจุบันแล้วเลือกเรียก `add`/`remove` ให้เอง เป็นการห่อ logic ไว้ที่ Notifier ชั้นเดียว ไม่ต้องเขียน if-else ซ้ำในทุก Widget ที่เรียกใช้

**การอ่าน/แก้ค่าใน Widget**:
- `ref.watch(favoritesProvider).any(...)` เพื่อเช็ค `isFav` — ต้อง watch เพราะไอคอนต้องเปลี่ยนทันทีที่สถานะเปลี่ยน (เทียบเท่า `context.watch`)
- `ref.read(favoritesProvider.notifier).toggle(item)` ตอนกดปุ่ม — ใช้ read เพราะเป็นคำสั่งครั้งเดียวตอนกด ไม่ต้องการให้ Widget ที่เรียกคำสั่งนี้ subscribe ซ้ำ (เทียบเท่า `context.read`)

## 3. `totalValueProvider` แยกจาก `favoritesProvider`

**ชนิด State**: App State (derived/computed state)

**เหตุผล**: มูลค่ารวมสามารถคำนวณจาก `favoritesProvider` ได้เสมอ จึงไม่จำเป็นต้องเก็บเป็นตัวแปรแยกใน Notifier (จะทำให้เกิดความเสี่ยงข้อมูลไม่ตรงกันถ้าลืมอัปเดตพร้อมกัน) ใช้ `Provider<double>` ที่ `ref.watch(favoritesProvider)` ข้างในแทน เป็นรูปแบบ "derived provider" ของ Riverpod

**ข้อดีเทียบกับการคำนวณ `fold()` ตรง ๆ ใน build()**: Riverpod แคชผลลัพธ์และ rebuild เฉพาะ Widget ที่ watch `totalValueProvider` เมื่อผลรวมเปลี่ยนค่าจริงเท่านั้น (ไม่ rebuild ทุกครั้งที่ `favoritesProvider` เปลี่ยนถ้าผลรวมบังเอิญเท่าเดิม) ต่างจาก Provider เดิมที่ต้อง watch ทั้ง `FavoritesModel` แล้วเรียก getter `totalValue` ทุกครั้งที่มีการเปลี่ยนแปลงใด ๆ ใน Model

## 4. FavoritesPage เป็น ConsumerWidget แยก Route

**เหตุผล**: เหมือนหลักการในโปรเจกต์หลัก — พิสูจน์ว่า Riverpod ส่งข้อมูลข้าม Route ได้โดยไม่ต้องส่งผ่าน constructor เลย เพราะ `favoritesProvider` เป็นตัวแปร global ที่ทุก `ConsumerWidget` เข้าถึงได้ผ่าน `ref` ไม่ว่าจะอยู่ Route ไหนก็ตาม

---

> ⚠️ ยังไม่ได้ทำ: โจทย์ที่ 3 (ค้นหาสินค้า + ปุ่มล้างรายการโปรดพร้อม Dialog ยืนยัน) จากใบงานส่วนที่ 5 ยังไม่ถูกย้ายมาทำในโปรเจกต์ทดลอง Riverpod นี้
