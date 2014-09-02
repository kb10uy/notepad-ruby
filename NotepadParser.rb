# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'
require 'pp'

class NotepadParser < Parslet::Parser
  rule(:space) {(comment|match('[ \t\v\f\r\n]')).repeat(1)}
  rule(:space?) {space.maybe}
  rule(:lparen) {str('(')>>space?}
  rule(:rparen) {str(')')>>space?}
  rule(:lbracket) {str('[')>>space?}
  rule(:rbracket) {str(']')>>space?}
  rule(:newline) {str(':')>>space?}
  rule(:endline) {str(';')>>space?}
  
  rule(:pnl) { str("\n") >> str("\r").maybe }
  
  rule(:comment) {
    comment_line|comment_multi
  }
  
  rule(:comment_line) {
    (str('//') >> (pnl.absent? >> any).repeat)
  }
  
  rule(:comment_multi) {
    (str('/*') >> (str('*/').absent? >> any).repeat >> str('*/'))
  }
  
  def self.symbols(syms)
    syms.each do |name,symbol|
      rule(name) { str(symbol) >> space? }
    end
  end
  
  def self.keywords(*names)
    names.each do |name|
      rule("#{name}_keyword") { str(name.to_s).as(:keyword) >> space? }
    end
  end
  
  symbols :assign_right_shift=>'>>=',
          :assign_left_shift=>'<<=',
          :bool_equ_s=>'===',
          :bool_neq_s=>'!==',
          :assign_plus=>'+=',
          :assign_minus=>'-=',
          :assign_multiple=>'*=',
          :assign_divide=>'/=',
          :assign_xor=>'^=',
          :assign_modulus=>'%=',
          :assign_or=>'|=',
          :assign_and=>'&=',
          :bool_equ=>'==',
          :bool_neq=>'!=',
          :bool_gre=>'>=',
          :bool_lee=>'<=',
          :module_access=>'::',
          :bool_andalso=>'&&',
          :bool_orelse=>'||',
          :right_shift=>'>>',
          :left_shift=>'<<',
          :increment=>'++',
          :decrement=>'--',
          :bool_grt=>'>',
          :bool_les=>'<',
          :plus=>'+',
          :minus=>'-',
          :multiple=>'*',
          :divide=>'/',
          :bin_xor=>'^',
          :modulus=>'%',
          :bin_or=>'|',
          :bin_and=>'&',
          :member=>'.',
          :invert=>'!',
          :assign=>'=',
          :comma=>','
          
  keywords :attr,:class,:def,:elif,:else,:false,:fed,
           :fi,:global,:if,:instance,:local,:nil,:porp,
           :prop,:rtta,:ssalc,:true,:iface,:ecafi,:module,:eludom,
           :for,:in,:continue,:rof,:while,:elihw,
           :switch,:case,:break,:default,:hctiws,:return,
           :include,:mix,:extd,:impl,:ovri,:natv,:self,
           :publ,:prot,:priv,:unless,:sselnu
  
  rule(:digit) {match('[0-9]')}
  rule(:alpha) {match('[a-zA-Z_]')}
  
  rule(:number) {(digit.repeat(1)>>(str('.')>>digit.repeat(1)).maybe).as(:number)>>space?}
  rule(:identifer) {(alpha>> (alpha|digit).repeat).as(:identifer) >>space?}
  
  rule(:string) {
    str('"') >> 
    (
      (str('\\') >> any) |
      (str('"').absent? >> any)
    ).repeat.as(:string) >> 
    str('"') >> space?
  }
  
  rule(:deco_access) {
    publ_keyword|
    prot_keyword|
    priv_keyword
  }
  
  rule(:op_prefix) {
    plus|minus|invert
  }
  
  rule(:op_postfix) {
    increment|decrement
  }
  
  rule(:op_assign) {
    assign_right_shift|
    assign_left_shift|
    assign_plus|
    assign_minus|
    assign_multiple|
    assign_divide|
    assign_xor|
    assign_modulus|
    assign_or|
    assign_and|
    assign
  }
  
  rule(:op_eq) {
    bool_equ_s|
    bool_neq_s|
    bool_equ|
    bool_neq
  }
  
  rule(:op_rel) {
    bool_gre|
    bool_lee|
    bool_grt|
    bool_les
  }
  
  rule(:op_shift) {
    right_shift|
    left_shift
  }
  
  rule(:op_add) {
    plus|
    minus
  }
  
  rule(:op_mul) {
    multiple|
    divide|
    modulus
  }
  
  rule(:factor) {
    string|number|identifer>>(lparen>>list_args.as(:args).maybe>>rparen).maybe|true_keyword|false_keyword|nil_keyword|
    lparen>>expr>>rparen
  }
  
  rule(:name_class) {
    identifer.as(:name) >> (module_access>>identifer.as(:name)).repeat
  }
  
  rule(:expr_assign) {
    (expr_unary.as(:left) >> op_assign.as(:op) >> expr_assign.as(:right)).as(:assign)|
    expr_bool_or
  }
  
  rule(:expr_bool_or) {
    (expr_bool_and.as(:left)>>
     bool_orelse>>
     expr_bool_or.as(:right)
    ).as(:expr_bool_or) | expr_bool_and
  }
  
  rule(:expr_bool_and) {
    (expr_or.as(:left)>>
     bool_andalso>>
     expr_bool_and.as(:right)
    ).as(:expr_bool_and) | expr_or
  }
  
  rule(:expr_or) {
    (expr_xor.as(:left)>>
     bin_or>>
     expr_or.as(:right)
    ).as(:expr_or) | expr_xor
  }
  
  rule(:expr_xor) {
    (expr_and.as(:left)>>
     bin_xor>>
     expr_xor.as(:right)
    ).as(:expr_xor) | expr_and
  }
  
  rule(:expr_and) {
    (expr_eq.as(:left)>>
     bin_and>>
     expr_and.as(:right)
    ).as(:expr_and) | expr_eq
  }
  
  rule(:expr_eq) {
    (expr_rel.as(:left)>>
     op_eq.as(:op)>>
     expr_eq.as(:right)
    ).as(:expr_eq) | expr_rel
  }
  
  rule(:expr_rel) {
    (expr_shift.as(:left)>>
     op_rel.as(:op)>>
     expr_rel.as(:right)
    ).as(:expr_rel) | expr_shift
  }
  
  rule(:expr_shift) {
    (expr_add.as(:left)>>
     op_shift.as(:op)>>
     expr_shift.as(:right)
    ).as(:expr_shift) | expr_add
  }
  
  rule(:expr_add) {
    (expr_mul.as(:left)>>
     op_add.as(:op)>>
     expr_add.as(:right)
    ).as(:expr_add) | expr_mul
  }
  
  rule(:expr_mul) {
    (expr_unary.as(:left)>>
     op_mul.as(:op)>>
     expr_mul.as(:right)
    ).as(:expr_mul) | expr_unary
  }
  
  rule(:expr_unary) {
    expr_post|
    (op_prefix.as(:op)>>factor).as(:expr_unary)|
    (increment>>expr_unary.as(:inc))|
    (decrement>>expr_unary.as(:dec))
  }
  
  rule(:expr_post) {
    factor>> (
      (lbracket>>expr>>rbracket)|
      (lparen>>list_args>>rparen)|
      (member>>identifer)|
      increment|decrement
    ).repeat
  }
  
  rule(:list_args) {
    expr_assign.as(:value) >> (comma>>expr_assign.as(:value)).repeat
  }
  
  rule(:list_method_args) {
    identifer.as(:name) >> (comma>>identifer.as(:name)).repeat
  }
  
  rule(:list_identifers) {
    identifer.as(:value) >> (comma>>identifer.as(:value)).repeat
  }
  
  rule(:list_classes) {
    name_class.as(:name) >> (comma>>name_class.as(:name)).repeat
  }
  
  rule(:expr) {
    expr_assign >> (comma >> expr_assign).repeat
  }
  
  rule(:method_calling) {
    (lparen>>list_args.maybe>>rparen)
  }
  ############式ここまで
  rule(:stmt_method) {
    expr>>endline|
    def_local_var|
    def_instance_var|
    def_class_var|
    def_global_var|
    block_if|block_for|line_if|later_if|
    block_while|block_unless|block_switch|
    return_keyword>>expr.as(:value)>>endline
  }
  
  rule(:stmt_class) {
    def_method|
    def_class_var|
    def_instance_var|
    def_global_var
  }
  
  rule(:stmt_module) {
    def_class|
    (include_keyword >> name_class.as(:name) >> endline).as(:include)
  }
  
  rule(:stmt_global) {
    def_method|
    def_class|
    def_module|
    def_global_var|
    block_if|block_for|line_if|later_if|
    block_while|block_unless|block_switch|block_switch|
    expr>>endline|
    return_keyword>>expr>>endline
  }
  
  rule(:stmt_block) {
    expr>>endline|
    def_local_var|
    def_instance_var|
    def_class_var|
    def_global_var|
    block_if|block_for|line_if|later_if|
    block_while|block_unless|block_switch|
    continue_keyword>>endline|
    break_keyword>>endline|
    return_keyword>>expr>>endline
  }
  
  rule(:program) {
    space?>>stmt_global.repeat
  }
  
  rule(:def_method) {
    (deco_access.as(:access).maybe>>
     ovri_keyword.as(:override).maybe>>
     natv_keyword.as(:native).maybe>>
     def_keyword.as(:start_method) >> identifer.as(:name) >>(lparen>>list_method_args.as(:args).maybe>>rparen).maybe >>newline>>
       stmt_method.as(:statement).repeat.as(:block)>>
     fed_keyword.as(:end_method)>>endline.maybe).as(:method)
  }
  rule(:def_class) {
    (deco_access.as(:access).maybe>>
     class_keyword.as(:start_class) >> identifer.as(:name) >> 
     (extd_keyword>>list_classes.as(:extends)).as(:extend).maybe >> 
     (impl_keyword>>list_classes.as(:implements)).as(:implement).maybe >> 
     newline>>
       stmt_class.as(:member).repeat.as(:members)>>
     ssalc_keyword.as(:end_class)>>endline.maybe).as(:class)
  }
  
  rule(:def_module) {
    (module_keyword.as(:start_module) >> identifer.as(:name) >>newline >>
      stmt_module.as(:member).repeat.as(:members)>>
     eludom_keyword.as(:end_module)>>endline.maybe).as(:module)
  }
  
  rule(:def_local_var) {
    local_keyword.as(:local_var) >> expr >> endline
  }
  
  rule(:def_instance_var) {
    instance_keyword.as(:instance_var) >> expr >> endline
  }
  
  rule(:def_class_var) {
    class_keyword.as(:class_var) >> expr >> endline
  }
  
  rule(:def_global_var) {
    global_keyword.as(:global_var) >> expr >> endline
  }
  
  rule(:block_if) {
    if_keyword.as(:start_if) >> expr.as(:cond) >> newline >>
      stmt_block.as(:statement).repeat.as(:block)>>
    (
     elif_keyword.as(:elif) >> expr.as(:cond) >> newline>>
       stmt_block.as(:statement).repeat.as(:block)
    ).as(:block_elif).repeat>>
    (
     else_keyword.as(:else) >> newline >>
       stmt_block.as(:statement).repeat.as(:block)
    ).as(:block_else).maybe>>
    fi_keyword.as(:end_if)>>endline.maybe
  }
  
  rule(:line_if) {
    if_keyword.as(:start_if) >> expr.as(:cond) >> newline >> expr.as(:target) >> endline
  }
  
  rule(:block_for) {
    (for_keyword.as(:start_for) >> identifer.as(:enum) >> in_keyword >> 
    expr.as(:target) >> newline>>
       stmt_block.as(:statement).repeat.as(:block) >>
     rof_keyword.as(:end_for)>>endline.maybe)
  }
  
  rule(:block_while) {
    (while_keyword.as(:start_while) >> expr.as(:cond) >> newline>>
       stmt_block.as(:statement).repeat.as(:block) >>
     elihw_keyword.as(:end_while)>>endline.maybe)
  }
  
  rule(:block_unless) {
    (unless_keyword.as(:start_unless) >> expr.as(:cond) >> newline>>
       stmt_block.as(:statement).repeat.as(:block) >>
     sselnu_keyword.as(:end_unless)>>endline.maybe)
  }
  
  rule(:later_if) {
    expr.as(:desc) >> if_keyword.as(:if_section) >> expr.as(:condition) >> endline
  }
  
  rule(:block_switch) {
    switch_keyword.as(:start_switch) >> expr.as(:base).maybe >> newline >>
      (
        case_keyword.as(:start_case) >> expr.as(:cond) >> newline >>
          stmt_block.as(:statement).repeat.as(:block)
      ).as(:case).repeat>>
      (
        default_keyword.as(:default) >> newline >>
          stmt_block.as(:statement).repeat.as(:block)
      ).as(:default).maybe>>
    hctiws_keyword.as(:end_switch)>>endline.maybe
  }
  
  root :program
  
end
