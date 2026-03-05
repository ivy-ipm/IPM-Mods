#!/data/data/com.termux/files/usr/bin/bash
# ==========================
# Termux C++ Interactive Tool
# ==========================

# Colors for UI
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Default folder for saving code and output
DOWNLOADS="/storage/emulated/0/Download"

# Memory to store code
code=""

while true; do
    clear
    echo -e "${BLUE}####################################################${NC}"
    echo -e "${BLUE}###           Termux C++ Interactive Tool       ###${NC}"
    echo -e "${BLUE}####################################################${NC}"
    echo
    echo -e "${YELLOW}Current memory code: ${#code} characters${NC}"
    echo
    echo -e "${GREEN}1) Import existing .cpp file${NC}"
    echo -e "${GREEN}2) Enter new C++ code${NC}"
    echo -e "${GREEN}3) Convert/save memory code to .cpp in Downloads${NC}"
    echo -e "${GREEN}4) Compile .cpp to .so / executable in Downloads${NC}"
    echo -e "${GREEN}5) Show current code in memory${NC}"
    echo -e "${GREEN}6) Exit${NC}"
    echo
    echo -n "Choose an option: "
    read choice

    case $choice in
        1)
            echo -n "Enter full path of existing .cpp file: "
            read src
            if [ -f "$src" ]; then
                code=$(cat "$src")
                echo -e "${GREEN}File imported successfully!${NC}"
            else
                echo -e "${RED}File not found!${NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -e "${GREEN}Enter your C++ code. Type END on a new line to finish.${NC}"
            temp=""
            while IFS= read -r line; do
                if [[ "$line" == "END" ]]; then
                    break
                fi
                temp+="$line"$'\n'
            done
            code="$temp"
            echo -e "${GREEN}Code saved in memory!${NC}"
            read -p "Press Enter to continue..."
            ;;
        3)
            if [ -z "$code" ]; then
                echo -e "${RED}No code in memory to save!${NC}"
            else
                echo -n "Enter filename (without extension) to save in Downloads: "
                read fname
                fname="${DOWNLOADS}/${fname}.cpp"
                echo "$code" > "$fname"
                echo -e "${GREEN}Code saved to Downloads as: ${fname}${NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            echo -n "Enter .cpp file name in Downloads to compile (without path): "
            read srcname
            src="${DOWNLOADS}/${srcname}"
            if [[ "$src" != *.cpp ]]; then
                src="${src}.cpp"
            fi
            if [ ! -f "$src" ]; then
                echo -e "${RED}File not found in Downloads!${NC}"
                read -p "Press Enter to continue..."
                continue
            fi
            echo -n "Enter output name (without extension) for Downloads: "
            read outname
            echo "Choose type: 1) .so  2) executable"
            read type
            if [ "$type" == "1" ]; then
                clang++ "$src" -shared -fPIC -target aarch64-linux-android21 -o "${DOWNLOADS}/${outname}.so"
                echo -e "${GREEN}.so compiled and saved in Downloads: ${DOWNLOADS}/${outname}.so${NC}"
            else
                clang++ "$src" -o "${DOWNLOADS}/${outname}"
                chmod +x "${DOWNLOADS}/${outname}"
                echo -e "${GREEN}Executable compiled and saved in Downloads: ${DOWNLOADS}/${outname}${NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        5)
            if [ -z "$code" ]; then
                echo -e "${RED}No code in memory!${NC}"
            else
                echo -e "${BLUE}######## Current Code in Memory ########${NC}"
                echo "$code"
                echo -e "${BLUE}######################################${NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        6)
            echo "Exiting..."
            break
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
