import 'package:cifra_app/features/create_transaction/domain/create_transaction/event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/ui/c1fra_icon.dart';
import 'package:cifra_app/features/create_transaction/domain/create_transaction/bloc.dart';
import 'package:cifra_app/features/create_transaction/domain/create_transaction/state.dart';
import 'package:cifra_app/repositories/categories/models/category.dart'
    as model;

class CreateTransactionView extends StatefulWidget {
  const CreateTransactionView({super.key});

  @override
  State<CreateTransactionView> createState() => _CreateTransactionViewState();
}

class _CreateTransactionViewState extends State<CreateTransactionView> {
  CreateTransactionBloc get _bloc => context.read<CreateTransactionBloc>();
  CreateTransactionState get _state => _bloc.state;

  List<Widget> get _categoryCards => _state.categories
      .map<Widget>((model.Category category) => CategoryCard(
            category: category,
            selected: category == _state.category,
            onTap: _handleCategoryTap,
          ))
      .toList();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<CreateTransactionBloc, CreateTransactionState>(
        builder: _builder,
        listener: _listener,
      );

  void _handleCategoryTap(model.Category category) =>
      _bloc.add(CreateTransactionEvent.update(
        title: _state.title,
        description: _state.description,
        category: category,
        amountInSmallestUnits: _state.amountInSmallestUnits,
        currency: _state.currency,
        type: _state.type,
        shouldConvertToBase: _state.amountInSmallestUnitsBase != null,
      ));

  Widget _builder(BuildContext context, CreateTransactionState state) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.vertical(
            top: Radius.circular(cardBorderRadius / 2),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              spacing: blankSpacerSize / 2,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: -35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _categoryCards,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  void _listener(BuildContext context, CreateTransactionState state) {
    if (state.status == CreateTransactionStatus.error) {
      final TextTheme textTheme = Theme.of(context).textTheme;
      final ColorScheme colorScheme = Theme.of(context).colorScheme;

      final String snackBarContent =
          !kDebugMode ? "Something went wrong" : "${state.e}\n${state.st}";

      final SnackBar snackBar = SnackBar(
        content: Text(
          snackBarContent,
          style: GoogleFonts.montserratAlternates(
            textStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onError,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius / 2),
        ),
        backgroundColor: colorScheme.error,
        showCloseIcon: true,
        closeIconColor: colorScheme.onError,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      );

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
    }
  }
}

typedef CategoryCallback = void Function(model.Category);

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  final model.Category category;
  final bool selected;
  final CategoryCallback? onTap;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: blankSpacerSize / 2,
        children: <Widget>[
          SizedBox.square(
            dimension: 70,
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadiusGeometry.circular(cardBorderRadius / 2),
              ),
              color: selected
                  ? Theme.of(context).colorScheme.surfaceContainerLow
                  : Theme.of(context).colorScheme.surfaceContainerLowest,
              child: InkWell(
                onTap: onTap != null ? () => onTap!(category) : null,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: C1fraIcon(
                    icon: category.icon.valueOrThrow,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          Text(
            category.name.valueOrThrow,
            style: GoogleFonts.montserratAlternates(
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      );
}
