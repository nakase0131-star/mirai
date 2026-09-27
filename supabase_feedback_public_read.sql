-- =========================================================
-- feedback テーブルを「公開掲示板」として使うための追加設定
-- ログインしていない一般の訪問者(anon)にも閲覧を許可します
-- Supabase SQL Editor に貼り付けて実行してください
-- =========================================================

create policy "Allow public read"
  on public.feedback
  for select
  to anon
  using (true);
