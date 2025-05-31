import argparse
import re
import sqlite3

from rich.console import Console
from rich.text import Text


def query_word(database_path, word_pattern):
    """
    查询单词并返回格式化结果
    """
    try:
        conn = sqlite3.connect(database_path)
        cursor = conn.cursor()
        query = """
        SELECT word, phonetic, definition, exchange, translation 
        FROM stardict 
        WHERE word = ?
        """
        cursor.execute(query, (f"{word_pattern}",))
        results = cursor.fetchall()
        conn.close()
        return results
    except sqlite3.Error as e:
        print(f"数据库错误: {e}")
        return []


def format_exchange(exchange_str):
    """
    格式化单词变形信息
    """
    if not exchange_str:
        return ""

    exchanges = []
    patterns = {
        "p": Text("过去式: ", style="bold cyan"),
        "d": Text("过去分词: ", style="bold cyan"),
        "i": Text("现在分词: ", style="bold cyan"),
        "3": Text("第三人称单数: ", style="bold cyan"),
        "r": Text("比较级: ", style="bold cyan"),
        "t": Text("最高级: ", style="bold cyan"),
        "s": Text("复数形式: ", style="bold cyan"),
    }

    for item in exchange_str.split("/"):
        if ":" in item:
            key, value = item.split(":", 1)
            if key in patterns:
                exchanges.append(patterns[key] + Text(value, style="italic") + ", ")

    return Text.assemble(*exchanges) if exchanges else ""


def center_text(text, width=80):
    """将文本居中显示在指定宽度内"""
    return f"{text:^{width}}"


def print_dictionary_entry(entry):
    """
    打印词典条目（纸质词典风格）
    """
    console = Console(width=80)
    word, phonetic, definition, exchange, translation = entry

    # 1. 单词标题
    console.print(Text(f"{word}", style="bold red underline"), justify="center")

    # 2. 音标
    console.print(Text(f"/{phonetic}/", style="cyan"), justify="center")

    # 3. 变形信息
    if exchange:
        console.print(format_exchange(exchange))

    # 4. 词性定义
    # 假设定义格式为: [词性] 定义内容 (如 "n. 苹果; 苹果树")
    if isinstance(definition, str):
        console.print("\n" + "─" * 80 + "\n", style="dim")
        for line in definition.split("\n"):
            if line.strip():
                # 检测词性缩写 (n., v., adj., adv.等)
                match = re.match(r"^([a-zA-Z]+\.)", line)
                if match:
                    pos = match.group(1)
                    rest = line[len(pos) :].strip()
                    console.print(Text(pos, style="white") + Text(rest, style="green"))
                else:
                    console.print(line)

    # 5. 中文翻译（带词性）
    if isinstance(translation, str):
        console.print("\n" + "─" * 80 + "\n", style="dim")
        for trans_line in translation.split("\n"):
            if trans_line.strip():
                match = re.match(r"^([a-zA-Z]+\.)", trans_line)
                if match:
                    pos_cn = match.group(0)
                    rest = trans_line.replace(pos_cn, "").strip()
                    console.print(
                        Text(pos_cn, style="white") + Text(rest, style="yellow")
                    )
                else:
                    console.print(Text(trans_line, style="yellow"))


def main():
    parser = argparse.ArgumentParser(
        description="英语词典查询工具", formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument("word", type=str, help="要查询的单词，精确查询")
    parser.add_argument(
        "-d",
        "--database",
        default="stardict.db",
        help="SQLite数据库路径（默认: stardict.db）",
    )
    args = parser.parse_args()

    console = Console(width=80)

    search_term = args.word

    results = query_word(args.database, search_term)

    if not results:
        console.print(f"[bold red]未找到包含 '{search_term}' 的单词[/]")
        return

    for entry in results:
        console.print("\n" + "═" * 80, style="blue")
        print_dictionary_entry(entry)
        console.print("\n" + "═" * 80, style="blue")


if __name__ == "__main__":
    main()
