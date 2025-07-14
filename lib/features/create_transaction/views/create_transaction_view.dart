import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/common/ui/selectable_button.dart';
import 'package:cifra_app/features/onboarding/views/onboarding_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/ui/c1fra_icon.dart';
import 'package:cifra_app/features/create_transaction/domain/create_transaction/bloc.dart';
import 'package:cifra_app/features/create_transaction/domain/create_transaction/state.dart';
import 'package:cifra_app/features/create_transaction/domain/create_transaction/event.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/categories/models/category.dart'
    as model;
import 'package:marquee/marquee.dart';

class CreateTransactionView extends StatefulWidget {
  const CreateTransactionView({super.key});

  @override
  State<CreateTransactionView> createState() => _CreateTransactionViewState();
}

class _CreateTransactionViewState extends State<CreateTransactionView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateTransactionBloc get _bloc => context.read<CreateTransactionBloc>();
  CreateTransactionState get _state => _bloc.state;

  List<Widget> get _categoryCards => _state.categories
      .map<Widget>((model.Category category) => Padding(
            padding: const EdgeInsets.only(left: blankSpacerSize / 2),
            child: CategoryCard(
              category: category,
              selected: category == _state.category,
              onTap: _handleCategoryTap,
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<CreateTransactionBloc, CreateTransactionState>(
        builder: _builder,
        listener: _listener,
      );

  void _handleTap() {
    if (_formKey.currentState?.validate() ?? false) {
      _bloc.add(CreateTransactionEvent.submit());
    }
  }

  void _handleCategoryTap(model.Category category) =>
      _bloc.add(CreateTransactionEvent.update(
        title: _state.title,
        description: _state.description,
        category: category,
        amountInSmallestUnits: _state.amountInSmallestUnits,
        currency: _state.currency,
        type: _state.type,
        shouldConvertToBase: _state.shouldConvertToBase,
      ));

  void _handleTypeChange(TransactionType? type) =>
      _bloc.add(CreateTransactionEvent.update(
        title: _state.title,
        description: _state.description,
        category: _state.category,
        amountInSmallestUnits: _state.amountInSmallestUnits,
        currency: _state.currency,
        type: type,
        shouldConvertToBase: _state.shouldConvertToBase,
      ));

  void _handleTitleChange(String title) =>
      _bloc.add(CreateTransactionEvent.update(
        title: title,
        description: _state.description,
        category: _state.category,
        amountInSmallestUnits: _state.amountInSmallestUnits,
        currency: _state.currency,
        type: _state.type,
        shouldConvertToBase: _state.shouldConvertToBase,
      ));

  void _handleCurrencyChange(Currency? currency) =>
      _bloc.add(CreateTransactionEvent.update(
        title: _state.title,
        description: _state.description,
        category: _state.category,
        amountInSmallestUnits: _state.amountInSmallestUnits,
        currency: currency,
        type: _state.type,
        shouldConvertToBase: _state.shouldConvertToBase,
      ));

  void _handleAmountChange(String amount) =>
      _bloc.add(CreateTransactionEvent.update(
        title: _state.title,
        description: _state.description,
        category: _state.category,
        amountInSmallestUnits: int.tryParse(amount.replaceAll(".", "")),
        currency: _state.currency,
        type: _state.type,
        shouldConvertToBase: _state.shouldConvertToBase,
      ));

  void _handleShouldConvertChange(bool? shouldConvert) =>
      _bloc.add(CreateTransactionEvent.update(
        title: _state.title,
        description: _state.description,
        category: _state.category,
        amountInSmallestUnits: _state.amountInSmallestUnits,
        currency: _state.currency,
        type: _state.type,
        shouldConvertToBase: shouldConvert ?? false,
      ));

  void _handleBackTap() => context.pop();

  Widget _builder(BuildContext context, CreateTransactionState state) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        spacing: blankSpacerSize / 2,
        children: [
          SizedBox(
            height: iconSize + 20.0,
            child: Row(
              spacing: blankSpacerSize / 2,
              children: [
                Expanded(
                  flex: 1,
                  child: SelectableButton(
                    tooltip: "Back",
                    onTap: _handleBackTap,
                    decoration: BoxDecoration(
                      color: colorScheme.shadow,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      children: <Widget>[
                        SizedBox.square(
                          dimension: textTheme.bodyMedium?.fontSize,
                          child: C1fraIcon(
                            icon: arrowLeft,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          "Back",
                          style: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        SizedBox.square(
                          dimension: textTheme.bodyMedium?.fontSize,
                          child: C1fraIcon(
                            icon: arrowLeft,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Marquee(
                      text: "add new transaction.",
                      fadingEdgeStartFraction: .1,
                      fadingEdgeEndFraction: .1,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(cardBorderRadius / 2),
              child: CupertinoSlidingSegmentedControl<TransactionType>(
                groupValue: _state.type,
                thumbColor: colorScheme.surfaceContainerLow,
                backgroundColor: colorScheme.surfaceContainerHighest,
                children: <TransactionType, Widget>{
                  TransactionType.expence: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(
                      "Expence",
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  TransactionType.income: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(
                      "Income",
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                },
                onValueChanged: _handleTypeChange,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadiusDirectional.vertical(
                  top: Radius.circular(cardBorderRadius / 2),
                ),
                color: colorScheme.surface,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: blankSpacerSize / 2,
                children: <Widget>[
                  TextFormField(
                    initialValue: _state.title,
                    style: GoogleFonts.montserratAlternates(
                      textStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "enter someting"
                        : null,
                    onChanged: _handleTitleChange,
                    decoration: InputDecoration(
                      labelText: "Transaction title",
                      labelStyle: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      fillColor: colorScheme.surfaceContainerHighest,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          cardBorderRadius / 2,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          cardBorderRadius / 2,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          cardBorderRadius / 2,
                        ),
                        borderSide: BorderSide(color: colorScheme.error),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          cardBorderRadius / 2,
                        ),
                        borderSide: BorderSide(color: colorScheme.error),
                      ),
                      errorStyle: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  FormField(
                    validator: (_) => _state.category == null
                        ? "please choose transaction category"
                        : null,
                    builder: (state) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: blankSpacerSize / 2,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              cardBorderRadius / 2,
                            ),
                            color: colorScheme.surfaceContainerHighest,
                            border: state.hasError
                                ? Border.all(color: colorScheme.error)
                                : null,
                          ),
                          padding: EdgeInsets.all(5),
                          height: 70 + 10 + 20 + 10,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            children: _categoryCards,
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              state.errorText ?? "",
                              style: GoogleFonts.montserratAlternates(
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      spacing: blankSpacerSize / 2.0,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: DropdownButtonFormField2<Currency>(
                              value: _state.baseCurrency,
                              items: Currency.values
                                  .map<DropdownMenuItem<Currency>>(
                                    (currency) => DropdownMenuItem<Currency>(
                                      value: currency,
                                      child: Text(
                                        "${currency.symbol} ${currency.name}",
                                      ),
                                    ),
                                  )
                                  .toList(),
                              validator: (value) =>
                                  value == null ? "choose one" : null,
                              onChanged: _handleCurrencyChange,
                              style: GoogleFonts.montserratAlternates(
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              iconStyleData: IconStyleData(iconSize: 0),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2.0,
                                    ),
                                    color: colorScheme.surface),
                              ),
                              decoration: InputDecoration(
                                labelText: " Currency",
                                labelStyle: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide: BorderSide.none,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide:
                                      BorderSide(color: colorScheme.error),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide:
                                      BorderSide(color: colorScheme.error),
                                ),
                                errorStyle: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              initialValue:
                                  _state.amountInSmallestUnits?.toString(),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: GoogleFonts.montserratAlternates(
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              inputFormatters: [
                                AutoDecimalTextInputFormatter(
                                  fractionDigits:
                                      _state.currency?.fractionDigits ?? 2,
                                ),
                              ],
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "enter someting"
                                      : null,
                              onChanged: _handleAmountChange,
                              decoration: InputDecoration(
                                labelText: "Amount",
                                labelStyle: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide: BorderSide.none,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide:
                                      BorderSide(color: colorScheme.error),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cardBorderRadius / 2),
                                  borderSide:
                                      BorderSide(color: colorScheme.error),
                                ),
                                errorStyle: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_state.currency != null &&
                      _state.currency != _state.baseCurrency)
                    Row(
                      spacing: blankSpacerSize / 2,
                      children: <Widget>[
                        Checkbox.adaptive(
                          value: _state.shouldConvertToBase,
                          onChanged: _handleShouldConvertChange,
                          fillColor: WidgetStatePropertyAll(
                            colorScheme.surfaceContainerHighest,
                          ),
                          checkColor: colorScheme.onSurface,
                          side: BorderSide.none,
                        ),
                        if (!_state.shouldConvertToBase)
                          Text(
                            "convert to base currency",
                            style: GoogleFonts.montserratAlternates(
                              textStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        if (_state.shouldConvertToBase &&
                            _state.amountInSmallestUnitsBase == null)
                          Text(
                            "converted to base currency: ...",
                            style: GoogleFonts.montserratAlternates(
                              textStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        if (_state.shouldConvertToBase &&
                            _state.amountInSmallestUnitsBase != null)
                          Text(
                            "converted to base currency: ${Money(amountInSmallestUnits: _state.amountInSmallestUnitsBase!, currency: _state.baseCurrency).formattedAmount}",
                            style: GoogleFonts.montserratAlternates(
                              textStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 150),
                    child: TextField(
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      scrollPadding: EdgeInsets.all(blankSpacerSize / 2),
                      onChanged: _handleTitleChange,
                      decoration: InputDecoration(
                        labelText: "Transaction description",
                        labelStyle: GoogleFonts.montserratAlternates(
                          textStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        alignLabelWithHint: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: const EdgeInsets.all(blankSpacerSize),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            cardBorderRadius / 2,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            cardBorderRadius / 2,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: blankSpacerSize * 2.5),
                    child: SelectableButton(
                      tooltip: "save",
                      onTap: state.status == CreateTransactionStatus.initial
                          ? _handleTap
                          : null,
                      content: switch (state.status) {
                        CreateTransactionStatus.initial => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5.0,
                            children: <Widget>[
                              SizedBox.square(
                                dimension: textTheme.bodyMedium?.fontSize,
                                child: C1fraIcon(
                                  icon: arrowRight,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                "save",
                                style: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              SizedBox.square(
                                dimension: textTheme.bodyMedium?.fontSize,
                                child: C1fraIcon(
                                  icon: arrowRight,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              )
                            ],
                          ),
                        CreateTransactionStatus.loading =>
                          CircularProgressIndicator.adaptive(),
                        CreateTransactionStatus.loaded => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5.0,
                            children: <Widget>[
                              SizedBox.square(
                                dimension: textTheme.bodyMedium?.fontSize,
                                child: C1fraIcon(
                                  icon: check,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                "done",
                                style: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              SizedBox.square(
                                dimension: textTheme.bodyMedium?.fontSize,
                                child: C1fraIcon(
                                  icon: check,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              )
                            ],
                          ),
                        CreateTransactionStatus.error => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5.0,
                            children: <Widget>[
                              SizedBox.square(
                                dimension: textTheme.bodyMedium?.fontSize,
                                child: C1fraIcon(
                                  icon: cross,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                "error",
                                style: GoogleFonts.montserratAlternates(
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              SizedBox.square(
                                dimension: textTheme.bodyMedium?.fontSize,
                                child: C1fraIcon(
                                  icon: cross,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              )
                            ],
                          ),
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(cardBorderRadius / 2),
        child: Material(
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(cardBorderRadius / 2),
            side: selected ? BorderSide() : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => onTap?.call(category),
            child: SizedBox(
              width: 70,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: blankSpacerSize / 2,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: C1fraIcon(
                        icon: category.icon.valueOrThrow,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    category.name.valueOrThrow,
                    style: GoogleFonts.montserratAlternates(
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
