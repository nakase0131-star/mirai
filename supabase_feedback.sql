-- =========================================================
-- チームみらい Webページ「ご意見」フォーム用テーブル
-- Supabase SQL Editor にそのまま貼り付けて実行してください
-- =========================================================

-- 1. テーブル作成
create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  name text,                              -- お名前(未入力可)
  message text not null check (char_length(message) > 0),  -- ご意見(必須)
  created_at timestamptz not null default now()
);

comment on table public.feedback is 'Webページ「ご意見」フォームからの投稿';
comment on column public.feedback.name is 'お名前(任意入力)';
comment on column public.feedback.message is 'ご意見・ご感想(必須)';

-- 2. Row Level Security を有効化(Supabaseでは新規テーブルは必ずRLSを有効にする)
alter table public.feedback enable row level security;

-- 3. 匿名ユーザー(anon)からの「投稿(INSERT)」のみ許可
--    フォームはログイン不要で送信できる想定
create policy "Allow public insert"
  on public.feedback
  for insert
  to anon
  with check (true);

-- 4. 閲覧(SELECT)は管理者(authenticated / service role)のみに限定
--    ※ダッシュボードの Table Editor は service role で参照するため影響なし
create policy "Allow authenticated read"
  on public.feedback
  for select
  to authenticated
  using (true);

-- 5. (任意) 投稿日時で並び替えしやすいようインデックスを付与
create index if not exists feedback_created_at_idx
  on public.feedback (created_at desc);
