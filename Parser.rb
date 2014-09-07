# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'
require 'pp'


module Notepad
  class Parser < Parslet::Parser
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
            :bool_in=>'~=',
            :bool_neq=>'!=',
            :bool_gre=>'>=',
            :bool_lee=>'<=',
            :pair_let=>'=>',
            :module_access=>'::',
            :range=>'..',
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
             :include,:mix,:extends,:implements,:override,:native,:self,
             :public,:protected,:private,:unless,:sselnu,
             :scr,:rcs,:lambda,:require,:as,:with,:to,:tree,:eert,:yield,
             :para,:arap
    
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
      protected_keyword|
      private_keyword|
      public_keyword
    }
    
    rule(:op_prefix) {
      plus.as(:plus)|minus.as(:minus)|invert.as(:invert)
    }
    
    rule(:op_postfix) {
      increment.as(:increment)|decrement.as(:decrement)
    }
    
    rule(:op_assign) {
      assign_right_shift.as(:with_right_shift)|
      assign_left_shift.as(:with_left_shift)|
      assign_plus.as(:with_plus)|
      assign_minus.as(:with_minus)|
      assign_multiple.as(:with_multiple)|
      assign_divide.as(:with_divide)|
      assign_xor.as(:with_xor)|
      assign_modulus.as(:with_modulue)|
      assign_or.as(:with_or)|
      assign_and.as(:with_and)|
      assign.as(:assign)
    }
    
    rule(:op_eq) {
      bool_equ_s.as(:equal_strict)|
      bool_neq_s.as(:not_equal_strict)|
      bool_equ.as(:equal)|
      bool_neq.as(:not_equal)|
      bool_in.as(:value_in)
    }
    
    rule(:op_rel) {
      bool_gre.as(:greater_equal)|
      bool_lee.as(:lesser_equal)|
      bool_grt.as(:greater)|
      bool_les.as(:lesser)
    }
    
    rule(:op_shift) {
      right_shift.as(:right_shift)|
      left_shift.as(:left_shift)
    }
    
    rule(:op_add) {
      plus.as(:plus)|
      minus.as(:minus)
    }
    
    rule(:op_mul) {
      multiple.as(:multiple)|
      divide.as(:divide)|
      modulus.as(:modulus)
    }
    
    rule(:factor) {
      true_keyword.as(:true)|false_keyword.as(:false)|nil_keyword.as(:nil)|
      string|number|tree|identifer|
      lparen>>expr_assign>>rparen|lparen>>value_block>>rparen|
      (lbracket>>list_expr.as(:list)>>rbracket).as(:array)|
      (lbracket>>expr_assign.as(:start)>>to_keyword.as(:to)>>expr_assign.as(:end)>>rbracket).as(:range)
    }
    
    rule(:tree) {
      (
        tree_keyword.as(:start_tree) >> newline >>
          (pair>>(comma>>(pair)).repeat).as(:pairs).maybe >>
        eert_keyword.as(:end_tree)
      ).as(:tree)
    }
    
    rule(:pair) {
      (identifer.as(:key) >> pair_let >> expr_bool_or.as(:value)).as(:pair)
    }
    
    rule(:name_class) {
      identifer.as(:name) >> (module_access>>identifer.as(:name)).repeat
    }
    
    rule(:expr_assign) {
      (expr_unary.as(:left) >> op_assign >> expr_assign.as(:right)).as(:assign)|
      expr_bool_or
    }
    
    rule(:expr_bool_or) {
      (expr_bool_and.as(:left)>>
       (bool_orelse.as(:orelse)>>
        expr_bool_and.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_bool_and
    }
    
    rule(:expr_bool_and) {
      (expr_or.as(:left)>>
       (bool_andalso.as(:andalso)>>
        expr_bool_or.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_or
    }
    
    rule(:expr_or) {
      (expr_xor.as(:left)>>
       (bin_or.as(:or)>>
        expr_xor.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_xor
    }
    
    rule(:expr_xor) {
      (expr_and.as(:left)>>
       (bin_xor.as(:xor)>>
        expr_and.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_and
    }
    
    rule(:expr_and) {
      (expr_eq.as(:left)>>
       (bin_and.as(:and)>>
        expr_eq.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_eq
    }
    
    rule(:expr_eq) {
      (expr_rel.as(:left)>>
       (op_eq>>
        expr_rel.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_rel
    }
    
    rule(:expr_rel) {
      (expr_shift.as(:left)>>
       (op_rel>>
        expr_shift.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_shift
    }
    
    rule(:expr_shift) {
      (expr_add.as(:left)>>
       (op_shift>>
        expr_add.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_add
    }
    
    rule(:expr_add) {
      (expr_mul.as(:left)>>
       (op_add>>
        expr_mul.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_mul
    }
    
    rule(:expr_mul) {
      (expr_unary.as(:left)>>
       (op_mul>>
        expr_unary.as(:right)).repeat(1)
      ).as(:expr_bin) | expr_unary
    }
    
    rule(:expr_unary) {
      expr_post|
      (
       (op_prefix>>expr_post.as(:right))|
       (increment.as(:earlier_increment)>>expr_post.as(:right))|
       (decrement.as(:earlier_decrement)>>expr_post.as(:right))
      ).as(:expr_unary)
    }
    
    rule(:expr_post) {
      (factor.as(:left)>> (
        (lparen>>list_args.maybe>>rparen).as(:method_call)|
        (lbracket>>expr_assign>>rbracket).as(:indexer)|
        (member>>identifer).as(:member_access)|
        increment.as(:later_increment)|decrement.as(:later_decrement)
      ).repeat(1).as(:posts)).as(:expr_post)|factor
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
    
    rule(:list_expr) {
      (expr_assign >> (comma >> expr_assign).repeat(1)).as(:list_expr)|expr_assign
    }
    
    ############式ここまで
    rule(:stmt_method) {
      def_local_var|
      def_instance_var|
      def_class_var|
      def_global_var|
      block_if|block_for|line_if|later_if|
      block_while|block_unless|block_switch|
      line_for|line_while|line_unless|
      return_keyword.as(:return)>>expr_assign.as(:value)>>endline|
      list_expr>>endline
    }
    
    rule(:stmt_class) {
      def_method|
      def_para|
      def_class_var|
      def_instance_var|
      def_global_var|
      def_property
    }
    
    rule(:stmt_module) {
      def_module|
      def_class|
      def_native_class|
      (include_keyword >> name_class.as(:name) >> endline).as(:include)
    }
    
    rule(:stmt_global) {
      def_method|
      def_para|
      def_class|
      def_native_class|
      def_module|
      def_global_var|
      block_script|
      line_require
    }
    
    rule(:stmt_script) {
      def_local_var|
      def_instance_var|
      def_class_var|
      def_global_var|
      block_if|block_for|line_if|later_if|
      block_while|block_unless|block_switch|
      line_for|line_while|line_unless|
      return_keyword.as(:return)>>expr_assign.as(:value)>>endline|
      list_expr>>endline
    }
    
    rule(:stmt_block) {
      def_local_var|
      def_instance_var|
      def_class_var|
      def_global_var|
      block_if|block_for|line_if|later_if|
      block_while|block_unless|block_switch|
      line_for|line_while|line_unless|
      continue_keyword.as(:continue)>>endline|
      break_keyword.as(:break)>>endline|
      return_keyword.as(:return)>>expr_assign.as(:value)>>endline|
      yield_keyword.as(:yield)>>expr_assign.as(:value)>>endline|
      list_expr>>endline
    }
    
    rule(:stmt_para) {
      list_expr>>endline|
      def_local_var|
      def_instance_var|
      def_class_var|
      def_global_var|
      block_if|block_for|line_if|later_if|
      block_while|block_unless|block_switch|
      line_for|line_while|line_unless|
      return_keyword.as(:return)>>expr_assign.as(:value)>>endline|
      yield_keyword.as(:yield)>>expr_assign.as(:value)>>endline
    }
    
    rule(:program) {
      space?>>stmt_global.repeat
    }
    
    rule(:def_method) {
      (deco_access.as(:access).maybe>>
       override_keyword.as(:override).maybe>>
       native_keyword.as(:native).maybe>>
       def_keyword.as(:start_method) >> identifer.as(:name) >>(lparen>>list_method_args.as(:args).maybe>>rparen).maybe >>newline>>
         stmt_method.as(:statement).repeat.as(:block)>>
       fed_keyword.as(:end_method)>>endline.maybe).as(:method)
    }
    rule(:def_para) {
      (
        deco_access.as(:access).maybe>>
        para_keyword.as(:start_para) >> identifer.as(:name) >>(lparen>>list_method_args.as(:args).maybe>>rparen).maybe >>newline>>
          stmt_para.as(:statement).repeat.as(:block)>>
        arap_keyword.as(:end_para)>>endline.maybe
      ).as(:para)
    }
    
    rule(:def_class) {
      (deco_access.as(:access).maybe>>
       class_keyword.as(:start_class) >> identifer.as(:name) >> 
       (extends_keyword>>list_classes.as(:extends)).as(:extend).maybe >> 
       (implements_keyword>>list_classes.as(:implements)).as(:implement).maybe >> 
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
      local_keyword.as(:local_var) >> list_expr >> endline
    }
    
    rule(:def_instance_var) {
      instance_keyword.as(:instance_var) >> list_expr >> endline
    }
    
    rule(:def_class_var) {
      class_keyword.as(:class_var) >> list_expr >> endline
    }
    
    rule(:def_global_var) {
      global_keyword.as(:global_var) >> list_expr >> endline
    }
    
    rule(:block_if) {
      if_keyword.as(:start_if) >> expr_assign.as(:cond) >> newline >>
        stmt_block.as(:statement).repeat.as(:block)>>
      (
       elif_keyword.as(:elif) >> expr_assign.as(:cond) >> newline>>
         stmt_block.as(:statement).repeat.as(:block)
      ).as(:block_elif).repeat>>
      (
       else_keyword.as(:else) >> newline >>
         stmt_block.as(:statement).repeat.as(:block)
      ).as(:block_else).maybe>>
      fi_keyword.as(:end_if)>>endline.maybe
    }
    
    rule(:line_if) {
      if_keyword.as(:start_if) >> expr_assign.as(:cond) >> newline >> list_expr.as(:target) >> endline
    }
    
    rule(:block_for) {
      (for_keyword.as(:start_for) >> identifer.as(:enum) >> in_keyword >> 
      expr_assign.as(:source) >> newline>>
         stmt_block.as(:statement).repeat.as(:block) >>
       rof_keyword.as(:end_for)>>endline.maybe)
    }
    
    rule(:line_for) {
      (for_keyword.as(:start_for) >> identifer.as(:enum) >> in_keyword >> 
      expr_assign.as(:source) >> newline>>
      list_expr.as(:target) >> endline)
    }
    
    rule(:block_while) {
      (while_keyword.as(:start_while) >> expr_assign.as(:cond) >> newline>>
         stmt_block.as(:statement).repeat.as(:block) >>
       elihw_keyword.as(:end_while)>>endline.maybe)
    }
    
    rule(:line_while) {
      (while_keyword.as(:start_while) >> expr_assign.as(:cond) >> newline>>
      list_expr.as(:target) >> endline)
    }
    
    rule(:block_unless) {
      (unless_keyword.as(:start_unless) >> expr_assign.as(:cond) >> newline>>
         stmt_block.as(:statement).repeat.as(:block) >>
       sselnu_keyword.as(:end_unless)>>endline.maybe)
    }
    
    rule(:line_unless) {
      (unless_keyword.as(:start_unless) >> expr_assign.as(:cond) >> newline>>
      list_expr.as(:target) >> endline)
    }
    
    rule(:later_if) {
      list_expr.as(:desc) >> if_keyword.as(:if_section) >> expr_assign.as(:cond) >> endline
    }
    
    rule(:block_switch) {
      switch_keyword.as(:start_switch) >> expr_assign.as(:base).maybe >> newline >>
        (
          case_keyword.as(:start_case) >> list_expr.as(:cond) >> newline >>
            stmt_block.as(:statement).repeat.as(:block)
        ).as(:case).repeat>>
        (
          default_keyword.as(:default) >> newline >>
            stmt_block.as(:statement).repeat.as(:block)
        ).as(:default).maybe>>
      hctiws_keyword.as(:end_switch)>>endline.maybe
    }
    
    rule(:block_script) {
      (scr_keyword.as(:start_script) >> newline >>
        stmt_script.as(:statement).repeat.as(:block) >>
      rcs_keyword.as(:end_script) >> endline.maybe).as(:script)
    }
    
    rule(:def_property) {
      (deco_access.as(:access).maybe>> prop_keyword.as(:start_property) >> identifer.as(:name) >> 
       (lparen>>deco_access.as(:get_access)>>comma>>deco_access.as(:set_access)>>rparen).maybe >>
       (assign >> expr_assign.as(:value)).maybe >> endline
      ).as(:property)
    }
    
    rule(:value_block) {
      val_line_if|val_block_if
    }
    
    rule(:val_line_if) {
      (expr_assign.as(:expr_true) >> else_keyword.as(:else_keyword) >> expr_assign.as(:expr_false) >>
       in_keyword.as(:in_keyword) >> expr_assign.as(:cond_false)
      ).as(:value_if)
    }
    
    rule(:val_block_if) {
      (if_keyword.as(:start_if) >> expr_assign.as(:cond) >> newline >>
        expr_assign.as(:value) >> endline >>
      (
       elif_keyword.as(:elif) >> expr_assign.as(:cond) >> newline>>
         expr_assign.as(:value) >> endline
      ).as(:block_elif).repeat>>
      (
       else_keyword.as(:else) >> newline >>
         expr_assign.as(:value) >> endline
      ).as(:block_else)>>
      fi_keyword.as(:end_if)
      ).as(:value_if)
    }
    
    rule(:line_require) {
      require_keyword >> string >> endline
    }
    
    rule(:def_native_method) {
      def_keyword.as(:start_method) >> identifer.as(:name) >> (as_keyword >> string.as(:name)).as(:native_name)
    }
    
    rule(:def_native_class) {
      (native_keyword.as(:native_class) >> class_keyword.as(:start_class) >> identifer.as(:name) >>
       with_keyword.as(:with) >> string.as(:library_name) >> newline >>
        (def_native_method >> endline).as(:native_method).repeat.as(:members) >>
       ssalc_keyword.as(:end_class)>>endline.maybe
      ).as(:native_class)
    }
    
    root :program
    
  end
end