use strict; # applies to all packages defined in the file

package SubSystem::TaggedFiles;
use 5.006;
use warnings;
use base qw(Class::Accessor);
__PACKAGE__->mk_accessors( qw/TagForSubject IdForPath / );

=head1 NAME
	SubSystem::TaggedFiles - IdForPath + TagForSubject + Sugar
=head1 VERSION
	Version 0.01
=cut

our $VERSION = '0.01';

=head1 SYNOPSIS
	TODO
=head1 EXPORT
	None
=head1 SUBROUTINES/METHODS
=head2 Critical Path
=head3 new
	create, config, return
=cut

sub new {
	my ( $class, $conf ) = @_;
	my $self = {};
	bless $self, $class;
	my $initresult = $self->_init( $conf );
	die $initresult->{fail} unless $initresult->{pass};
	return $self;
}

=head3 _init
	This will be replaced by e.g. CachedDB setup variants - there's an argumentto be made that it should just accept objects derived from the base classes, but that's not the point at the moment
=cut

sub _init {
	my ( $self, $conf ) = @_;
	return {pass => 1};
}

=head3 file_instance_without_subject
	get the first instance of files without a subject - the id of a file without a subjet, and the first instance ofthat file
=cut

sub file_instance_without_subject {
	my ( $self, $params ) = @_;
	my $result = $self->_file_instance_without_subject( $params );
	return $result unless $result->{pass};

	my $return = [];

	for my $id ( @{$result->{pass}} ) {
		my $instance_result = $self->IdForPath->get_any_instance( $id );
		if ( $instance_result->{pass} ) {
			push( @{$return}, $instance_result->{pass} );
		}
	}
	if ( @{$return} ) {
		return {pass => $return};
	}
	return {fail => "No instances found"};
}

=head3 get_untagged_file_path
	get the first path for a file subject that has no or not enough tags
=cut

sub get_untagged_file_path {
	my ( $self, $p ) = @_;
	$self->_get_untagged_file_path();
}

=head2 Facilitators/Wrappers
	Methods in the module that change a value or the module state and can be tested in isolation
	Usually inculdes wrappers that validate and set default values for private method calls
=cut

sub validate_some_value {
	my ( $self, $p, $value ) = @_;
	die unless ( $p->{$value} );
}

=head2 Private Functions
	The heavy lifting which might be done differently in child classes
=cut

sub _get_untagged_file_path {
	my ( $self, $p ) = @_;
	die( 'not implemented' );
}

=head1 AUTHOR

mmacnair, C<< <mmacnair at cpan.org> >>

=head1 BUGS

	TODO Bugs

=head1 SUPPORT

	TODO Support

=head1 ACKNOWLEDGEMENTS
	TODO 

=head1 LICENSE AND COPYRIGHT

Copyright 2018 mmacnair.

This program is distributed under the (Revised) BSD License:
L<http://www.opensource.org/licenses/BSD-3-Clause>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of mmacnair's Organization
nor the names of its contributors may be used to endorse or promote
products derived from this software without specific prior written
permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;
