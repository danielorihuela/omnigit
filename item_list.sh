#!/bin/bash

select_items() {
    print_heading=$1
    local -n items=$2
    local -n choices=$3

    current_index=0
    while (( $? == 0 )) ; do
        $print_heading 
        _show_list 
        read -n 1 key
        clear
        _perform_action $key
    done
}

_show_list() {
    for num in ${!items[@]}; do
	line=""
	if [[ $current_index == $num ]]; then
	    line="->"
	else
	    line="  "
	fi
	echo "$line [${choices[num]:- }] ${items[num]}"
    done

    _print_keys_legend
}

_print_keys_legend() {
    echo -e "\nKeys:"
    echo "  j -> go down"
    echo "  k -> go up"
    echo "  x -> check/uncheck option"
    echo "  a -> check all"
    echo "  u -> uncheck all"
    echo "  d -> done"
}

_perform_action() {
    key=$1
    case "$key" in
	'j') if [[ $current_index -lt $((${#items[@]} - 1)) ]]; then
		 ((current_index+=1));
	     fi;;
	'k') if [[ $current_index -gt 0 ]]; then
		 ((current_index--));
	     fi ;;
	'x') _toggle_item $choices;;
	'a') _check_all_items $items $choices;;
	'u') _uncheck_all_items $items $choices;;
	'd') return 1;;
    esac
}

_toggle_item() {
    if [[ "${choices[current_index]}" ]]; then
        choices[current_index]=""
    else
        choices[current_index]="X"
    fi
}

_check_all_items() {
    for position in ${!items[@]}; do
        choices[position]="X"
    done
}

_uncheck_all_items() {
    for position in ${!items[@]}; do
        choices[position]=""
    done
}


print_selected_items() {
    title=$1
    local -n items=$2
    local -n choices=$3

    echo "Selected ${title}:"
    for position in ${!choices[@]}; do
        if [[ ${choices[position]} ]]; then
            echo "  - ${items[position]}"
        fi
    done
}

selected_item() {
    local -n choices=$1
    position=$2

    if [[ -z ${choices[position]} ]]; then
        return 1
    fi
}
