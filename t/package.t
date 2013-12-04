use strict;
use warnings;
use Test::More;
use Compiler::Lexer;
use Compiler::Parser;
use Compiler::Parser::AST::Renderer;

subtest 'package' => sub {
    my $tokens = Compiler::Lexer->new('')->tokenize('package Person; sub new { my $class = shift; bless {}, $class; } package main; 1 + 1;');
    my $ast = Compiler::Parser->new->parse($tokens);
    Compiler::Parser::AST::Renderer->new->render($ast);
    is(ref $ast->root, 'Compiler::Parser::Node::Package');
    is(ref $ast->root->next, 'Compiler::Parser::Node::Function');
    is(ref $ast->root->next->body, 'Compiler::Parser::Node::Branch');
    is(ref $ast->root->next->body->left, 'Compiler::Parser::Node::Leaf');
    is(ref $ast->root->next->body->right, 'Compiler::Parser::Node::FunctionCall');
    is(ref $ast->root->next->body->next, 'Compiler::Parser::Node::FunctionCall');
    is(ref $ast->root->next->body->next->{args}[0], 'Compiler::Parser::Node::Branch');
    is(ref $ast->root->next->body->next->{args}[0]->left, 'Compiler::Parser::Node::HashRef');
    is(ref $ast->root->next->body->next->{args}[0]->right, 'Compiler::Parser::Node::Leaf');
    is(ref $ast->root->next->next, 'Compiler::Parser::Node::Package');
    is(ref $ast->root->next->next->next, 'Compiler::Parser::Node::Branch');
    is(ref $ast->root->next->next->next->left, 'Compiler::Parser::Node::Leaf');
    is(ref $ast->root->next->next->next->right, 'Compiler::Parser::Node::Leaf');
};

subtest 'use base' => sub {
    my $tokens = Compiler::Lexer->new('')->tokenize('package Person; use base "Base"; 1;');
    my $ast = Compiler::Parser->new->parse($tokens);
    Compiler::Parser::AST::Renderer->new->render($ast);
    is(ref $ast->root, 'Compiler::Parser::Node::Package');
    is(ref $ast->root->next, 'Compiler::Parser::Node::Module');
    is(ref $ast->root->next->args, 'Compiler::Parser::Node::Leaf');
    is(ref $ast->root->next->next, 'Compiler::Parser::Node::Leaf');
};

done_testing;
